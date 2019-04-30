#!/bin/bash

gam() { "/Users/joey.wu/bin/gam/gam" "$@" ; }

set -o errexit
set -o nounset
set -o pipefail

clear

echo ""
read -p "Enter the email address of the user to administer: " email
echo "Administering $email..."
echo ""

gsuite_add_groups() {

  read -p "Enter the groups to add, NO COMMAS. Put a space in between: " mult_groups

  for add in ${mult_groups[@]}
  do
    echo ""
    echo "Adding $email to group: " $add
    echo ""
    gam update group $add add member $email
    echo "Done! $email added to group $add..."
    echo ""
  done

}

gsuite_add_groups
