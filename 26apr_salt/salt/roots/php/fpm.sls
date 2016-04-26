# General PHP-FPM configuration

/etc/php/7.0/fpm/php-fpm.conf:
  file.managed:
    - source: salt://php/files/etc/php/7.0/fpm/php-fpm.conf

/etc/php/7.0/fpm/pool.d/www.conf:
  file.managed:
    - source: salt://php/files/etc/php/7.0/fpm/pool.d/www.conf

# Enable or disable FPM service
php7.0-fpm:
  service:
    - running
    - enable: True
