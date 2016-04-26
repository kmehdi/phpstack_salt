{{ pillar['php']['ext_dir'] }}/oci8.so:
  file.managed:
    - source: {{ pillar['php']['baseurl'] }}/files/{{ php.ext_version }}/oci8.so
    - user: root
    - group: root
    - mode: 0755
    - template: jinja
    - require:
      - file: /usr/include/oracle/11.2/client
      - file: /usr/lib/oracle/11.2/client
      - file: /etc/profile.d/oracle.sh

/usr/include/oracle/11.2/client:
  file.symlink:
    - target: /usr/include/oracle/11.2/client64
    - require:
      - pkg: oracle-client

/usr/lib/oracle/11.2/client:
  file.symlink:
    - target: /usr/lib/oracle/11.2/client64
    - require:
      - pkg: oracle-client

/etc/profile.d/oracle.sh:
  file.managed:
    - source: {{ pillar['php']['baseurl'] }}/files/oracle.sh
    - user: root
    - group: root
    - mode: 0755
    - template: jinja

php-enable-oci8:
  file.managed:
    - name: {{ pillar['php']['ext_ini_dir'] }}/oci8.ini
    - user: root
    - group: root
    - mode: 644
    - contents: 'extension=oci8.so'


debian-mod-enable:
  cmd.run:
    - name: phpenmod oci8
    - onlyif: type phpenmod
    - require:
      - file: {{ pillar['php']['ext_ini_dir'] }}/oci8.ini

