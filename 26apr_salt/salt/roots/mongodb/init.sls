mongo_repo:
  pkgrepo.managed:
    - humanname: MongoDB 3.2 Repo
    - name: deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse
    - file: /etc/apt/sources.list.d/mongodb-3.2.list
    - keyid: EA312927
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: mongodb-org

/etc/init/mongo.conf:
  file.managed:
    - source: {{ pillar['mongodb']['saltfiles'] }}/mongo.init.tmpl
    - template: jinja
    - require_in:
      - pkg: mongodb-org

/etc/mongod.conf:
  file.managed:
    - source: {{ pillar['mongodb']['saltfiles'] }}/mongod.conf.tmpl
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - require_in:
      - pkg: mongodb-org

mongodb-org:
  pkg.installed

mongod:
  service.running:
    - require:
      - pkg: mongodb-org
    - watch:
      - file: /etc/mongod.conf
