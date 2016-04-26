include:
  - percona.common
  - percona.client

percona-server:
  debconf:
    - set
    - name: percona-server-server-5.6
    - data:
        'percona-server-server/root_password':
          type: password
          value: {{ salt['pillar.get']('percona:passwords:root', '') }}
        'percona-server-server/root_password_again':
          type: password
          value: {{ salt['pillar.get']('percona:passwords:root', '') }}

  pkg:
    - latest
    - name: percona-server-server-5.6
    - require:
      - debconf: percona-server
