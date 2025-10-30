#!/bin/bash

## Description: Run PHP Code Beautifier and Fixer
## Usage: phpcbf [options] [path]
## Example: "ddev phpcbf" or "ddev phpcbf web/modules/custom"

$DDEV_COMPOSER_ROOT/vendor/bin/phpcbf "$@"
