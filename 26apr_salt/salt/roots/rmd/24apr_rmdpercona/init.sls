debconf-utils:
  pkg.installed

percona_repo:
  pkgrepo.managed:
    - humanname: percona APT Repo
    - name: deb http://repo.percona.com/apt trusty main
    - file: /etc/apt/sources.list.d/percona.list
    - keyid: 1C4CBDCDCD2EFD2A
    - keyserver: keys.gnupg.net
  pkg.installed:
        - pkgs:
            - percona-server-server-5.6
            - percona-server-client-5.6
    service.running:
        - enable: True
        - name: mysql
        - watch:
        - file: /etc/mysql/my.cnf

/etc/mysql/my.cnf:
  file:
    - managed
    - source: salt://percona/files/my.cnf.jinja
    - template: jinja
    - mode: 644

mysql_setup:
  debconf.set:
    - name: mysql-server
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': '{{ salt['pillar.get']('mysql:root_pw', '') }}' }
        'mysql-server/root_password_again': {'type': 'password', 'value': '{{ salt['pillar.get']('mysql:root_pw', '') }}' }
    - require:
      - pkg: debconf-utils

python-mysqldb:
  pkg.installed

mysql-server:
  pkg.installed:
    - require:
      - debconf: mysql-server
      - pkg: python-mysqldb

mysql:
  service.running:
    - watch:
      - pkg: mysql-server
      - file: /etc/mysql/my.cnf

/etc/mysql/my.cnf:
  file.managed:
    - source: salt://mysql/files/etc/mysql/my.cnf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 640
    - require:
      - pkg: mysql-server

