# PHP Extensions:
{% from 'php/macros/php_module.sls' import php_module with context %}

oci8:
  pecl.installed

/etc/php/7.0/mods-available/oci8.ini:
  file.managed:
    - source: salt://php/files/etc/php/7.0/mods-available/oci8.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pecl: oci8

{{ php_module('oci8', true, 'fpm') }}
{{ php_module('oci8', true, 'cli') }}


##########
mongodb-beta:
  pecl.installed

/etc/php/7.0/mods-available/mongo.ini:
  file.managed:
    - source: salt://php/files/etc/php/7.0/mods-available/mongo.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pecl: mongodb-beta

{{ php_module('mongodb', true, 'fpm') }}
{{ php_module('mongodb', true, 'cli') }}


# If pillar enables xdebug - install and configure it
{% if salt['pillar.get']('php:enable_xdebug', True) %}
xdebug:
  pecl.installed

/etc/php/7.0/mods-available/xdebug.ini:
  file.managed:
    - source: salt://php/files/etc/php/7.0/mods-available/xdebug.ini
    - user: root
    - group: root
    - mode: 644
    - require:
      - pecl: xdebug

{{ php_module('xdebug', true, 'fpm') }}
{{ php_module('xdebug', true, 'cli') }}
{% else %}
{{ php_module('xdebug', false, 'fpm') }}
{{ php_module('xdebug', false, 'cli') }}
{% endif %}


# Configure Zend OpCache extension - no need to install, as it ships with # php5-common package from dotdeb-php56
/etc/php/7.0/mods-available/opcache.ini:
  file.managed:
    - source: salt://php/files/etc/php/7.0/mods-available/opcache.ini
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/etc/php/7.0/cli/conf.d/05-opcache.ini:
  file.absent

/etc/php/7.0/fpm/conf.d/05-opcache.ini:
  file.absent


{% if salt['pillar.get']('php:enable_opcache', True) %}
{{ php_module('opcache', true, 'fpm') }}
{{ php_module('opcache', true, 'cli') }}
{% else %}
{{ php_module('opcache', false, 'fpm') }}
{{ php_module('opcache', false, 'cli') }}
{% endif %}

