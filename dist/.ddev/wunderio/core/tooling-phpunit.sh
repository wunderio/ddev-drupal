#!/bin/bash

#
# Helper script to run PHPUnit.
#

set -eu
if [[ -n "${WUNDERIO_DEBUG:-}" ]]; then
    set -x
fi
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/var/www/html/vendor/bin

if [ ! -f "$DDEV_APPROOT/phpunit.xml" ]; then
    echo "phpunit.xml not found! Please run 'ddev regenerate-phpunit-config'."
    exit 1
fi

$DDEV_COMPOSER_ROOT/vendor/bin/phpunit "$@"
