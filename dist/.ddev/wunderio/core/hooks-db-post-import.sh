#!/bin/sh

#
# Helper script to run posb-import db hook.
#

set -exu
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/var/www/html/vendor/bin

cd $DDEV_COMPOSER_ROOT && drush cache:rebuild -y && drush @local user:login