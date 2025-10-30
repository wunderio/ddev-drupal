#!/usr/bin/env bash

## Description: Runs codecept commands.
## Usage: codecept
## Example: "ddev codecept"

$DDEV_COMPOSER_ROOT/vendor/bin/codecept "$@"
