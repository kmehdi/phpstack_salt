nginx:
  pkg.installed

/etc/nginx/sites-available/default:
  file:
    - source: salt://nginx/default
    - user: www-data
    - group: www-data
    - mode: 664
    - require:
      - pkg: nginx

