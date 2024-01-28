#!/bin/sh

#
# Helper script to run host post-start commands.
#

set -exu
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/app/vendor/bin

ddev status
