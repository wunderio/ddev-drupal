#!/usr/bin/env bash

## Description: Runs codecept commands.
## Usage: codecept
## Example: "ddev codecept"

if [ ! -f "$DDEV_COMPOSER_ROOT/vendor/bin/codecept" ]; then
  echo "Composer binaries for Codecept missing; exiting early."
  exit 0
fi

$DDEV_COMPOSER_ROOT/vendor/bin/codecept "$@"
