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
    color_green="\033[38;5;70m"
    color_reset="\033[0m"

    printf "${color_green}Drupal is working, running drush uli: "
    ddev drush uli
    printf "${color_reset}"
fi
