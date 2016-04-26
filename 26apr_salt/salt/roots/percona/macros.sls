{%- macro mysql_user(name, host, password, state='present') -%}
"mysql_user_{{ name }}_{{ host }}":
  mysql_user:
    - {{ state }}
    - name: "{{ name }}"
    - host: "{{ host }}"
    - password: "{{ password }}"
    - connection_unix_socket: /var/run/mysqld/mysqld.sock
    - connection_user: root
    - connection_pass: {{ salt['pillar.get']('percona:passwords:root', '') }}
    - connection_db: mysql
    - require:
      - service: mysql
{%- endmacro -%}

{%- macro mysql_database(name, state='present') -%}
mysql_database_{{ name }}:
  mysql_database:
    - {{ state }}
    - name: "{{ name }}"
    - connection_unix_socket: /var/run/mysqld/mysqld.sock
    - connection_user: root
    - connection_pass: {{ salt['pillar.get']('percona:passwords:root', '') }}
    - connection_db: mysql
    - require:
      - service: mysql
{%- endmacro -%}

{%- macro mysql_grant(user, host, database, grant='ALL PRIVILEGES', grant_option=False, state='present') -%}
"mysql_grants_{{ user }}_{{ host }}_{{ database }}":
   mysql_grants:
    - {{ state }}
    - user: "{{ user }}"
    - host: "{{ host }}"
    - database: "{{ database }}"
    - grant: "{{ grant }}"
    - grant_option: {{ grant_option }}
    - connection_unix_socket: /var/run/mysqld/mysqld.sock
    - connection_user: root
    - connection_pass: {{ salt['pillar.get']('percona:passwords:root', '') }}
    - connection_db: mysql
    - require:
      - mysql_user: "mysql_user_{{ user }}_{{ host }}"
{%- endmacro -%}

