php7_ppa:
  pkgrepo.managed:
      - ppa: ondrej/php
# Setup PHP environment
include:
  - .dependencies
  - .install
  - .config
  - .extensions
  - .fpm
