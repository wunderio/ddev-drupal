#!/bin/sh

#
# Helper script to run web post-start commands.
#

set -eu
if [ -n "${WUNDERIO_DEBUG:-}" ]; then
    set -x
fi
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/app/vendor/bin
