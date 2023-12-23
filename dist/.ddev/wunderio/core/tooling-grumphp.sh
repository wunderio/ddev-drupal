#!/bin/sh

#
# Helper script to run GrumPHP.
#

set -exu
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/var/www/html/vendor/bin

php /var/www/html/vendor/bin/grumphp "$@"
