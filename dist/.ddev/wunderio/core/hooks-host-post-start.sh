#!/bin/sh

#
# Helper script to run host post-start commands.
#

set -eu
if [ -n "${WUNDERIO_DEBUG:-}" ]; then
    set -x
fi
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/app/vendor/bin

# Commands to run if Drupal is working.
if ddev drush status bootstrap | grep -q 'Successful'; then
    ddev drush uli
fi
