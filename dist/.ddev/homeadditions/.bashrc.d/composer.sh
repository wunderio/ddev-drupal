#!/bin/bash

#
# Set custom composer root vendor binaries.
#

# Avoid fonky patterns.
if [ -n "${DDEV_COMPOSER_ROOT+x}" ]; then
    export PATH="$PATH:$DDEV_COMPOSER_ROOT/vendor/bin"
fi
