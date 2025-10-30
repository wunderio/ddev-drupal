#!/usr/bin/env bash

## Description: Runs drush phpcs commands.
## Usage: phpcs
## Example: "ddev phpcs"

$DDEV_COMPOSER_ROOT/vendor/bin/phpcs "$@"
