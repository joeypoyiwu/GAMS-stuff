#!/bin/bash

gam() { "/Users/joey.wu/bin/gam/gam" "$@" ; }

set -o errexit
set -o nounset
set -o pipefail

while :
do
  clear
  echo "What would you like to do?"
  echo
  echo "1. Delete user from a group"
  echo "2. Delete user from all groups"
  echo "3. Add User to Group"
  echo "4. Transfer Drive resources to another user"
  echo "5. Undelete a user"
  echo "6. Check if Email Address is User, Group, or Alias"
  echo "7. Get User Information"
  echo "8. Delete a User"
  echo "9. Rename a User"
  echo "10. Create a User"
  echo "11. Create a Google Group"
  echo "12. Delete a Google Group"
  echo "99. Exit"
  echo
  echo "Script will timeout in 30 seconds if no option is selected."
  read -t 30 opt

if [ $opt -lt 10 ]; then #You can change the value here to match your options. This is just a simple argument for me to keep track
  read -p "Enter the email address you would like to make changes to: " email
  echo "Administering $email..."
elif [ $opt -gt 9 ]; then
  echo "Choosing $opt..."
fi
  case $opt in
    1)read -p "Enter the group email address to edit: " groupemail
      echo "Editing $groupemail..."
      gam update group $groupemail remove user $email
      echo "User deleted from group. Press the enter key to continue"
      read enterKey;;

    2)echo "Deleting user from all Groups"
      read -p "Are you sure you want to delete $email from all groups?
      Type 1 for Yes, 2 for No: " deleteallgroups_confirm
        if [ $deleteallgroups_confirm -eq 1 ]; then
          gam user $email delete Groups
          echo "Completed. $email modified."
          echo "User $email deleted from all groups. Press the enter key to continue"
        else
          echo "Cancelling command..."
        fi
      read enterKey;;

    3)read -p "Are you adding the user to multiple groups? Type 1 for Yes, 2 for No: " multiplegroups
      while [ $multiplegroups -eq 1 ] ;
      do
        read -p "Type 1 to continue adding to groups. Type 2 to cancel: " multiplegroups
          if [ $multiplegroups -eq 1 ]; then
            read -p "Enter the group email address to add $email to: " addtogroup
            echo "Are you sure you want to add $email to $addtogroup?"
            echo
            read -p "Type 1 for Yes, 2 for No: " addtogroup_confirm
            if [ $addtogroup_confirm -eq 1 ]; then
              gam update group $addtogroup add member $email
              echo "Task completed."
            fi
          fi
      done
      if [ $multiplegroups -eq 2 ]; then
        echo "Got it. Cancelling command..."
      fi
      read enterKey;;

    4)read -p "Enter the email address to transfer files TO: " driveemail
      read -p "Are you sure you want to transfer $email to $driveemail? Type 1 for Yes, 2 for No: " transfer_confirm
        if [ $transfer_confirm -eq 1 ]; then
          gam user $email transfer drive $driveemail
          echo "Transferring Drive files from $email to $driveemail..."
          echo "Completed. $email modified."
          echo "Files transferred. Press the enter key to continue"
        else
          echo "Cancelling command..."
        fi
      read enterKey;;

    5)#read -p "Enter the email address of the user to undelete (Note: This will only undelete users that were deleted within the past 5 days): " undeleteuser
      read -p "Are you sure you want to restore $email? Type 1 for Yes, 2 for No: " restore_confirm
        if [ $transfer_confirm -eq 1 ]; then
          gam undelete user $email
          echo "Restoring $email..."
          echo "Completed. $email recovered."
          echo "User undeleted. Press the enter key to continue"
        else
          echo "Cancelling command..."
        fi
      read enterKey;;

    6)echo "Getting information for $email..."
      gam info user $email
      echo "Info retrieved. Press the enter key to continue"
      read enterKey;;

    7)echo "Getting information for $email..."
      gam whatis $email
      echo "Information retrieved. Press the enter key to continue"
      read enterKey;;

    8)read -p "Are you sure you want to delete $email? Type 1 for Yes, 2 for No: " deleteuser_confirm
        if [ $deleteuser_confirm -eq 1 ]; then
          gam delete user $email
          echo "Deleting user $email..."
          echo "Completed. $email deleted."
          echo "User deleted. Press the enter key to continue..."
        else
          echo "Cancelling command..."
        fi
       read enterKey;;

    9)read -p "What would you like to rename the first name to? : " rename_firstname
      read -p "What would you like to rename the last name to? : " rename_lastname
      gam update user $email firstname $rename_firstname lastname $rename_lastname
      echo "Completed. $email has been updated with first name $rename_firstname and last name $rename_lastname. Press enter to continue..."
      read enterKey;;

    10)read -p "Enter the first name of the user: " first_name
       read -p "Enter the last name of the user: " last_name
       read -p "Enter the email address for the user: " create_email
       echo "Creating user $first_name $last_name with the email address $create_email..."
       gam create user $create_email firstname "$first_name" lastname "$last_name"
       echo "User $create_email created. Press the enter key to continue"
       read enterKey;;

    11)read -p "Enter the email address of the new group you would like to create: " creategroup
       echo "Creating group $creategroup..."
       gam create group $creategroup
       echo "Group $creategroup created. Press the enter key to continue"
       read enterKey;;

    12)read -p "Enter the email address of the group you would like to delete: " deletegroup
       read -p "Are you sure you want to delete group $deletegroup? Type 1 for Yes, 2 for No: " deletegroup_confirm
        if [ $deletegroup_confirm -eq 1 ]; then
          gam delete group $deletegroup
          echo "Deleting group $deletegroup..."
          echo "Group $deletegroup deleted. Press the enter key to continue"
        else
          echo "Cancelling command..."
        fi
       read enterKey;;
    # 13)read -p "Enter the email address of the group you would like to update: " updategroup
    #    read -p "Are you sure you want to edit the group $updategroup? Type 1 for Yes, 2 for No: " updategroup_confirm
    #     if [ $updategroup_confirm -eq 1 ]; then
    #       read -p "Enter the list of emails you would like to make changes to, separated by spaces. e.g.: test@moogsoft.com test2@moogsoft.com: " updategroup_members
    #       gam update group $updategroup add member user $updategroup_members
    #       echo "Updating group $updategroup..."
    #       echo "Group $updategroup updated. Press the enter key to continue."
    #     else
    #       echo "Cancelling command..."
    #     fi
    #   read enterKey;;
    # # 13)read -p "Preparing to export current list of all suspended users. Are you sure? Type 1 for Yes, 2 for No: " export_suspended_confirm
    #     if [ $export_suspended_confirm -eq 1 ]; then
    #       read -p "Enter the last login time for the set of users you would like to pull.
    #       PLEASE enter UTC time format in this format or it won't work. Example: 2013-01-01T00:00:00.000Z will pull in those not logged in since beginning of the year: " lastlogin
    #       gam report users filter 'accounts:last_login_time<$lastlogin'
    #       echo "Report exported as CSV."
    #     else
    #       echo "Cancelling command..."
    #     fi
    #    read enterKey;;

    99)echo "Bye!"
       echo "░░░░█▐▄▒▒▒▌▌▒▒▌░▌▒▐▐▐▒▒▐▒▒▌▒▀▄▀▄░
░░░█▐▒▒▀▀▌░▀▀▀░░▀▀▀░░▀▀▄▌▌▐▒▒▒▌▐░
░░▐▒▒▀▀▄▐░▀▀▄▄░░░░░░░░░░░▐▒▌▒▒▐░▌
░░▐▒▌▒▒▒▌░▄▄▄▄█▄░░░░░░░▄▄▄▐▐▄▄▀░░
░░▌▐▒▒▒▐░░░░░░░░░░░░░▀█▄░░░░▌▌░░░
▄▀▒▒▌▒▒▐░░░░░░░▄░░▄░░░░░▀▀░░▌▌░░░
▄▄▀▒▐▒▒▐░░░░░░░▐▀▀▀▄▄▀░░░░░░▌▌░░░
░░░░█▌▒▒▌░░░░░▐▒▒▒▒▒▌░░░░░░▐▐▒▀▀▄
░░▄▀▒▒▒▒▐░░░░░▐▒▒▒▒▐░░░░░▄█▄▒▐▒▒▒
▄▀▒▒▒▒▒▄██▀▄▄░░▀▄▄▀░░▄▄▀█▄░█▀▒▒▒▒"
       exit 1;;

    *)echo "$opt is an invalid option. Please select a number shown on the menu."
      echo "Press the enter key to continue..."
      read enterKey;;
  esac
done

echo Done!
read enterKey;;
