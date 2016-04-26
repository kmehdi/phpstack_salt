include:
  - percona.repo

debconf-utils:
  pkg.installed

# Import the macros we use
{% from "percona/macros.sls" import mysql_user with context %}
{% from "percona/macros.sls" import mysql_database with context %}
{% from "percona/macros.sls" import mysql_grant with context %}

# We need the python libs for the macros
python-mysqldb:
  pkg:
    - installed

mysql:
  service:
  - running
  - require:
    - pkg: percona-server
    - pkg: python-mysqldb

########################
## General Configuration
/etc/mysql:
  file:
    - directory
    - user: root
    - group: root
    - mode: 755

/etc/mysql/my.cnf:
  file:
    - managed
    - source: salt://percona/templates/my.cnf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/mysql
    - require_in:
      - pkg: percona-server


############################
## Required Users and Grants
{{ mysql_user("root", "localhost", salt['pillar.get']('percona:passwords:root', '')) }}
{{ mysql_grant("root", "localhost", "*.*", grant_option=True) }}

####################################
## Custom Users, Database and Grants
{% for name, database in salt['pillar.get']('percona:databases', {}).iteritems() %}
{{ mysql_database(name, state=database.get('state', 'present')) }}
{% endfor %}

{% for name, user in salt['pillar.get']('percona:users', {}).iteritems() -%}
{{ mysql_user(user.get("name", name), user.get("host", "localhost"), user.get("password", "")) }}
{% endfor %}

{% for grant in salt['pillar.get']('percona:grants', []) -%}
{{ mysql_grant(grant.get('user'), grant.get("host", "localhost"), grant.get("database", "*.*"), grant.get("grant", None)) }}
{% endfor %}
