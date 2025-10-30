#!/usr/bin/env bash

## Description: Runs PHPUnit commands.
## Usage: phpunit
## Example: "ddev phpunit"

if [ ! -f "$DDEV_APPROOT/phpunit.xml" ]; then
    echo "phpunit.xml not found! Please run 'ddev regenerate-phpunit-config'."
    exit 1
fi

$DDEV_COMPOSER_ROOT/vendor/bin/phpunit "$@"
