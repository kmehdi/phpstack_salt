get-composer:
  cmd.run:
    - cwd: /vagrant
    - name: 'CURL=`which curl`; $CURL -sS https://getcomposer.org/installer | php'
    - unless: test -f /usr/local/bin/composer

install-composer:
  cmd.wait:
    - name: mv /vagrant/salt/roots/composer/composer.phar /usr/local/bin/composer
    - cwd: /vagrant
    - unless: test -f /usr/local/bin/composer
    - watch:
      - cmd: get-composer
