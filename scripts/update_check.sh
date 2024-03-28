#!/bin/bash

#
# Update check script executed on Composer update and install.
#

set -eu
if [[ -n "${WUNDERIO_DEBUG:-}" ]]; then
    set -x
fi
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/var/www/html/vendor/bin

# Get the latest version of a package via Composer.
get_latest_version() {
    # Run composer show to get information about the package
    package_info=$(composer show wunderio/ddev-drupal --all)

    # Extract the versions and get the latest one
    version=$(echo "$package_info" | grep -oP '(?<=versions : \* ).*' | tr -d ' ' | cut -d ',' -f 1)

    # Remove leading and trailing spaces
    version=$(echo "$version" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

    echo "$version"
}

# Get the current version from the first argument.
current_version=$1

# Get the latest version from Composer.
latest_version=$(get_latest_version)

# Compare the current version with the latest version.
# If they are the same, exit the script.
if [[ $current_version == $latest_version ]]; then
    exit 0
fi

echo "A newer version of wunderio/ddev-drupal is available. Current version is: $current_version, latest version is: $latest_version."

# Prompt the user with a yes or no question.
read -rp "Do you want update to latest version? (yes/no): [y] " answer

# Convert the input to lowercase for case-insensitive comparison.
answer=${answer,,}

# If the answer is empty (user pressed Enter), default to "y".
answer=${answer:-y}

# Check the user's input and perform actions accordingly
if [[ $answer == "yes" ]] || [[ $answer == "y" ]]; then
    composer require wunderio/ddev-drupal --dev
    echo "Staging the changes to GIT. "
    git add .ddev composer.json composer.lock
    git status
    echo "Please verify the above wunderio/ddev-drupal changes before committing."
else
    echo "Skipping the update."
fi
