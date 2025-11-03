#!/bin/bash

#
# Helper script to run post-import db hook.
#

set -eu
if [[ -n "${WUNDERIO_DEBUG:-}" ]]; then
    set -x
fi

source $DDEV_APPROOT/.ddev/wunderio/core/_helpers.sh

cd "$DDEV_APPROOT"

if [[ -n "${WUNDERIO_DEBUG:-}" ]]; then
  display_status_message "Skip db hooks after import"
  exit 0
fi

# Every import is treated as deployment
# Unfied based https://www.drush.org/12.x/deploycommand/.
drush updatedb --no-cache-clear -y && drush sqlsan -y && drush cache:rebuild && drush config:import -y && drush cache:rebuild && drush deploy:hook

uli_link=$(drush uli)
display_status_message "Drupal is working, running drush uli: $uli_link"
