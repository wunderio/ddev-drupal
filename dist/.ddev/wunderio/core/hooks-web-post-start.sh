#!/bin/bash

#
# Helper script to run web post-start commands.
#

set -eu
if [[ -n "${WUNDERIO_DEBUG:-}" ]]; then
    set -x
fi
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/var/www/html/vendor/bin

# Check if the DDEV_APPROOT environment variable is set
if [ -z "${DDEV_APPROOT+x}" ]; then
  echo "The DDEV_APPROOT environment variable is not set."
  echo "This may indicate that your DDEV version is outdated."
  echo "Please update DDEV to the latest version."
  echo ""
  echo "You can update DDEV using one of the following methods, depending on your installation:"
  echo ""
  echo "For Homebrew (macOS):"
  echo "  brew upgrade ddev"
  echo ""
  echo "For Debian/Ubuntu (including WSL2 with Debian/Ubuntu):"
  echo "  sudo apt-get update && sudo apt-get upgrade"
  echo ""
  echo "For Fedora, Red Hat, etc.:"
  echo "  sudo dnf upgrade ddev"
  echo ""
  echo "For Arch Linux:"
  echo "  yay -Syu ddev-bin"
  echo ""
  echo "For manual installations, please follow the instructions at:"
  echo "  https://docs.ddev.com/en/stable/users/install/ddev-upgrade/"
  echo ""
  exit 1
fi

source $DDEV_APPROOT/.ddev/wunderio/core/_helpers.sh

# Function to check if Drupal is working.
is_drupal_working() {
    # Drush 11 and older.
    status=$(drush status bootstrap 2>&1)
    if echo "$status" | grep -q "Successful"; then
        # "Successful" found, Drupal is working.
        return 0
    fi

    # Drush 12 and newer.
    status=$(drush status --field=bootstrap 2>&1)
    if echo "$status" | grep -q "Successful"; then
        # "Successful" found, Drupal is working.
        return 0
    fi

    return 1
}

# Commands to run if Drupal is working.
if is_drupal_working; then
    uli_link=$(drush uli)
    display_status_message "Drupal is working, running drush uli: $uli_link"
fi
