#!/bin/sh

#
# Autoupdate
#

set -exu
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/var/www/html/vendor/bin

# Prompt the user with a yes or no question
read -p "Do you want to continue? (yes/no): " answer

# Convert the input to lowercase for case-insensitive comparison
answer=${answer,,}

# Check the user's input and perform actions accordingly
if [[ $answer == "yes" ]]; then
    echo "You chose to continue."
    # Perform actions for 'yes'
elif [[ $answer == "no" ]]; then
    echo "You chose to stop."
    # Perform actions for 'no'
else
    echo "Invalid input. Please enter 'yes' or 'no'."
fi
