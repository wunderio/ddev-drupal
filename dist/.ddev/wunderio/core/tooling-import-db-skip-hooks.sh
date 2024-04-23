#!/bin/bash

#
# Import db skipping post-import-db hooks.
#
# Maybe one day they'll implement --skip-hooks:
# https://github.com/ddev/ddev/issues/2129
#

set -u
if [[ -n "${WUNDERIO_DEBUG:-}" ]]; then
    set -x
fi
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin

source .ddev/wunderio/core/_helpers.sh

# Define the path to the DDEV config file
CONFIG_FILE=".ddev/config.wunderio.yaml"

# Function to disable post-import-db hooks in the DDEV config file.
disable_post_import_db_hooks() {
    sed -i '/^ *post-import-db:$/,/^ *- exec:.*/ s/^/#/' "$CONFIG_FILE"
}

# Function to enable post-import-db hooks in the DDEV config file.
enable_post_import_db_hooks() {
    # Reset the config file to its original state.
    # Hide "Updated 1 path from the index" message.
    git checkout "$CONFIG_FILE" > /dev/null 2>&1
}

# Disable post-import-db hooks.
disable_post_import_db_hooks
# Run import-db.
ddev import-db "$@"
# Re-enable post-import-db hooks after import-db is done.
enable_post_import_db_hooks
