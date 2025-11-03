#!/bin/bash

#
# Helper functions.
#

set -eu
if [[ -n "${WUNDERIO_DEBUG:-}" ]]; then
    set -x
fi

# Since we run this on host too.
if [ -n "${DDEV_COMPOSER_ROOT+x}" ]; then
    export PATH="$PATH:$DDEV_COMPOSER_ROOT/vendor/bin"
fi

# Function to display status message
display_status_message() {
    local color_green="\033[38;5;70m"
    local color_reset="\033[0m"
    local message="$1"

    printf "${color_green}${message}${color_reset}\n"
}
