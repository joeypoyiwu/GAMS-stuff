#!/bin/bash
#figure out a way to get that if statement for gsuite_offboard_gdrive somewhere else so it doesn't run before the other commands.
#Also see if there's a way to run it silently in the background.

gam() { "/Users/joey.wu/bin/gam/gam" "$@" ; }

set -o errexit
set -o nounset
set -o pipefail

clear
gsuite_offboard_prompt() {
  #Constant variables
  offboardlastname="DEPARTED"
  domain="@moogsoft.com"


  read -p "Enter the email address of the user to be offboarded: " offboardemail
  echo "Checking $offboardemail..."
  gam info user $offboardemail
  echo ""
  echo "*********************************"
  echo "Make sure this is the correct user."
  echo ""
  read -p "Enter the FULL NAME of the user: "  offboardfullname
  echo "Do you need to transfer any Google Drive files OR set an email forward?"
  read -p "Type "yes" or "no" exactly: " transfer_confirm
  if [ "$transfer_confirm" = "yes" ]; then
    read -p "Enter the email of the email to forward $offboardemail's emails to: " forward_email
    read -p "Enter the email of the user to transfer $offboardemail's GDrive files to: " transferemail
    gsuite_offboard_main
    gsuite_forward_email
    gsuite_offboard_gdrive
  elif [ "$transfer_confirm" = "no" ]; then
    echo ""
    echo "Got it. GDrive file transfer will not be a part of the offboarding process."
    echo ""
    gsuite_offboard_main
  fi
}

gsuite_offboard_main() {

  #Remove User from All Groups
  echo "Removing $offboardemail from all groups..."

  gam user $offboardemail delete Groups
  echo ""

  #Set User to be suspended
  echo "Setting user $offboardemail to be suspended..."
  gam update user $offboardemail suspended off
  echo ""

  #Change First Name to Full Name of User + Current Date
  offboard_date=$(date +"(%m/%d/%Y)")
  offboard_end_date=$offboardfullname" $offboard_date"
  echo "Changing first name of $offboardemail to reflect current date $offboard_date..."
  gam update user $offboardemail firstname "$offboard_end_date"
  echo ""

  #Change Last Name of user to say "DEPARTED". This is mainly for automation for CSV export.
  echo "Changing last name of $offboardemail to 'DEPARTED'..."
  gam update user $offboardemail lastname $offboardlastname
  echo "User $offboardemail's last name has been changed to $offboardlastname..."
  echo "User first name is now $offboard_end_date".
  echo ""

  #Set User OU to Terminated
  echo "Setting OU (organizational unit) for $offboardemail to Terminated..."
  gam update user $offboardemail org "Terminated Users"
  echo "User $offboardemail has been moved to the Terminated OU."
  echo ""

  #Set User GAL to be hidden
  echo "Setting GAL for $offboardemail to be turned off..."
  gam update user $offboardemail gal off
  echo "User $offboardemail's GAL has been turned off."
  echo ""

}

gsuite_forward_email() {
  #Set email forward to manager
  forward_email+=$domain
  echo "Setting forwarding for $offboardemail..."
  gam user $offboardemail add forwardingaddress $forward_email
  gam user $offboardemail forward on $forward_email keep
  echo "User $offboardemail's emails have been set to forward to $forward_email..."
  echo ""
}

gsuite_offboard_gdrive() {
  #Set User GDrive Transfer to another User
  echo "Transferring $offboardemail's GDrive files to $transferemail..."
  gam user $offboardemail transfer drive $transferemail
  echo "Done. $offboardemail's GDrive files transferred to $transferemail."
  echo ""
}

gsuite_offboard_prompt

echo "Offboarding completed!"
