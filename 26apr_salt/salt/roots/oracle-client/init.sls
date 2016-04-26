{% from "oracle-client/map.jinja" import oracleclient with context %}

{% set baseurl = "salt://oracle-client" %}

oracle-client:
  pkg.installed:
    - sources:
      - oracle-instantclient11.2-basic: {{ baseurl }}/packages/{{ oracleclient.basic }}
      - oracle-instantclient11.2-devel: {{ baseurl }}/packages/{{ oracleclient.devel }}
      - oracle-instantclient11.2-sqlplus: {{ baseurl }}/packages/{{ oracleclient.sqlplus }}
