python-mysqldb:
  pkg:
    - installed

mysql-server-5.5:
  pkg:
    - installed
  service.running:
    - name: mysql
    - watch:
      - pkg: python-mysqldb
      - file: /etc/mysql/my.cnf

/etc/mysql/my.cnf:
  file:
    - managed
    - source: salt://vespakoen/mysql/files/my.cnf
    - template: jinja
    - mode: 644
    - require:
        - pkg: mysql-server-5.5

{%- for database, args in pillar['mysql'].get('databases', {}).iteritems() %}
{{ database }}_database:
  mysql_database.present:
    - name: {{ database }}
  mysql_user.present:
    - name: {{ args.get('user') }}
    - host: '{{ args.get('host', 'localhost') }}'
    - password_hash: "{{ args.get('password_hash') }}"
  mysql_grants.present:
    - database: {{ database }}.*
    - user: {{ args.get('user') }}
    - host: '{{ args.get('host', 'localhost') }}'
    - grant: ALL PRIVILEGES
  require:
    - pkg: python-mysqldb
    - service: mysql

{{ database }}_database_unicode:
  module.run:
    - name: mysql.query
    - database: mysql
    - query: "ALTER DATABASE {{ database }} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"

{#
{{ database }}_database_create:
  module.run:
    - name: mysql.query
    - database: {{ database }}
    - query: "CREATE DATABASE IF NOT EXISTS {{ database }} DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;"

{{ database }}_database_grants:
  module.run:
    - name: mysql.query
    - database: {{ database }}
    - query: "GRANT ALL PRIVILEGES ON {{ database }}.* TO {{ args.get('user') }} @'%' IDENTIFIED BY '{{ args.get('password') }}';"
#}
{%- endfor %}

