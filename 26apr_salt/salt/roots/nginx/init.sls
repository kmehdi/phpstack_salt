# Make sure nginx is installed and up
nginx:
  pkg:
    - installed
  service.running:
    - require:
      - pkg: nginx
      - file: /etc/nginx


### CONFIG FILES ###


# Configuration files for nginx
/etc/nginx:
  file.recurse:
    - source: salt://nginx/config
    - user: root
    - group: root
    - file_mode: 644

### VHOSTS ###

# symlink the site
/etc/nginx/sites-enabled/jscore.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/jscore.conf
    - user: www-data
    - group: www-data

