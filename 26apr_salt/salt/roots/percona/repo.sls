#
percona-repo:
  pkgrepo:
    - managed
    - file: /etc/apt/sources.list.d/percona.list
    - name: deb http://repo.percona.com/apt trusty main
    - human_name: Percona Apt Repo
    - keyid: 1C4CBDCDCD2EFD2A
    - keyserver: keys.gnupg.net
    - require_in:
      - pkg: percona-server
      - pkg: percona-client
