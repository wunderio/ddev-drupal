#!/bin/sh

#
# Helper script to run posb-import db hook.
#

set -eu
if [ -n "${WUNDERIO_DEBUG:-}" ]; then
    set -x
fi
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/var/www/html/vendor/bin

cd $DDEV_COMPOSER_ROOT && drush cache:rebuild -y && drush @local user:login
