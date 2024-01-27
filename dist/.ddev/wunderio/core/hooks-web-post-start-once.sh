#!/bin/sh

#
# Helper script to run web commands on first post start.
#
# This is run only if there's no vendor folder. There's no 'build'
# command as we have in Lando so we have this instead.
#

set -exu
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/var/www/html/vendor/bin

composer install
