#!/bin/sh

#
# Helper script to run pmu, but also create temporary module directory if it doesn't exist.
#

set -u
if [ -n "${WUNDERIO_DEBUG:-}" ]; then
    set -x
fi
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/var/www/html/vendor/bin

# Define the module machine name passed as an argument
module_name="$1"

if [ -z "$module_name" ]; then
    echo "Please provide the module machine name as an argument."
    exit 0
fi

cd /var/www/html

# Check if the module directory exists.
if [ ! -d "web/modules/contrib/$module_name" ] && [ ! -d "web/modules/custom/$module_name" ] && [ ! -d "web/core/modules/$module_name" ]; then
    # If the directory doesn't exist, create it
    echo "Creating directory for module $module_name..."
    mkdir -p "web/modules/custom/$module_name"

    # Create the .info.yml file inside the directory
    touch "web/modules/custom/$module_name/$module_name.info.yml"
    echo "name: 'Dummy module created by ddev pmu'" >> "web/modules/custom/$module_name/$module_name.info.yml"
    echo "type: module" >> "web/modules/custom/$module_name/$module_name.info.yml"
    echo "core_version_requirement: ^9 || ^10 || ^11" >> "web/modules/custom/$module_name/$module_name.info.yml"

    # Run "drush pmu" command.
    echo "Disabling module $module_name..."
    drush cr
    drush pmu -y "$module_name"

    # Remove the temporary directory.
    echo "Removing directory for module $module_name..."
    rm -rf "web/modules/custom/$module_name"
else
    # Run "drush pmu" command.
    echo "Disabling module $module_name..."
    drush pmu -y "$module_name"
fi
