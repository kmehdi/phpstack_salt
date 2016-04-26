nginx:
  pkg:
    - installed

nginx_run:
  service.running:
    - name: nginx
    - enable: True
    - watch:
      - file: /etc/nginx/nginx.conf
      - file: /etc/nginx/sites-available/jscore.conf
    - require:
      - file: /etc/nginx/sites-enabled/jscore.conf
      - file: /etc/nginx/nginx.conf
      - pkg: nginx

/etc/nginx/nginx.conf:
  file:
    - managed
    - source: salt://nginx/nginx.conf
    - user: root
    - group: root
    - mode: 644

/etc/nginx/sites-available/jscore.conf:
  file:
    - managed
    - source: salt://nginx/jscore.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nginx

/etc/nginx/sites-enabled/jscore.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/jscore.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/nginx/sites-available/jscore.conf

/etc/nginx/sites-enabled/default:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require:
      - pkg: nginx
