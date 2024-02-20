#!/bin/bash

#
# Helper script to run host post-start commands.
#

set -eu
if [ -n "${WUNDERIO_DEBUG:-}" ]; then
    set -x
fi
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/app/vendor/bin

# Function to check if Drupal is working.
is_drupal_working() {
    # Drush 11 and older.
    output1=$(ddev drush status bootstrap 2>&1)
    # Drush 12 and newer.
    output2=$(ddev drush status --field=bootstrap 2>&1)
    output="$output1$output2"

    # Check if "Successful" is present in the combined output
    if [[ $output == *"Successful"* ]]; then
        # "Successful" found, Drupal is working.
        return 0
    else
        # "Successful" not found, Drupal is not working.
        return 1
    fi
}

# Commands to run if Drupal is working.
if is_drupal_working; then
    color_green="\033[38;5;70m"
    color_reset="\033[0m"

    printf "${color_green}Drupal is working, running drush uli: "
    ddev drush uli
    printf "${color_reset}"
fi
