#!/usr/bin/env bash

# Install and configure xdebug here, based on environment

# See for explanation of following notation: https://unix.stackexchange.com/a/405518
if (( "10#0${XDEBUG_ENABLE}" != 0 )); then
    echo "Install and configure xdebug"

    pecl install xdebug
    # See for configuration options: http://xdebug.org/docs/
    printf "xdebug.default_enable = 1\n\
xdebug.collect_params = 4\n\
xdebug.collect_vars = 0\n\
xdebug.show_local_vars = 1\n\
\n\
xdebug.remote_connect_back = 0\n\
xdebug.remote_host = ${XDEBUG_REMOTE_HOST}\n\
xdebug.remote_enable = 1\n\
xdebug.remote_port = 9000\n" | tee "$XDEBUG_SETTINGS_TARGET"

    docker-php-ext-enable xdebug
else
    echo "Disable xdebug (if installed)"
    printf "xdebug.default_enable = 0\n" | tee "$XDEBUG_SETTINGS_TARGET"
fi

# Setup folder permissions here

# Setup example folder
#mkdir -p example/
#find example/ -type d -exec chmod 777 {} \;
#find example/ -type f -exec chmod 666 {} \;

# Setup database config
#if [ ! -f config/database.php ]; then
#    echo "Initialize project configuration"
#    cp config/database.php.docker.dist config/database.php
#fi

# Do composer install
#composer -q install --no-plugins --no-scripts --dev

docker-php-entrypoint "$1"