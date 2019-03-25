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
  echo "6. Update User Information"
  echo "7. Get User Information"
  echo "8. Delete a User"
  echo "9. Update a User"
  echo "10. Create a User"
  echo "11. Create a Google Group"
  echo "12. Delete a Google Group"
  echo "99. Exit"
  echo
  echo "***Script will timeout in 30 seconds if no option is selected.***"
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
      echo "Info retrieved. You can now update the user."
      echo "If you do not want a value for a field, just leave it empty and press Enter."
      read -p "Are you sure you want to edit the User information for $email? Type 1 for Yes, 2 for No: " update_confirm
        if [ $update_confirm -eq 1 ]; then
          read -p "Enter user's job title here: " job_title
          read -p "Enter user's department here: " dept_name
          read -p "Enter user's manager email here: " manager_name
          read -p "Enter user's employment type here:: " desc_name
          gam update user $email relation manager $manager_name organization title $job_title department $dept_name description $desc_name primary
          echo "Completed. Printing new user information..."
          echo "*********************************************"
          gam info user $email
          echo "Completed. Press enter to continue..."
        else
          echo "Cancelling command. Press enter to continue..."
        fi
      read enterKey;;


    7)echo "Getting information for $email..."
      gam whatis $email
      echo "Information retrieved. Press the enter key to continue"
      read enterKey;;


    8)echo "Printing information on $email. Make sure this is the correct user."
      gam info user $email
      echo "Information for $email printed. Make sure this is the correct user."
      read -p "Are you sure you want to delete $email? Type 1 for Yes, 2 for No: " deleteuser_confirm
        if [ $deleteuser_confirm -eq 1 ]; then
          gam delete user $email
          echo "Deleting user $email..."
          echo "Completed. $email deleted."
          echo "User deleted. Press the enter key to continue..."
        else
          echo "Cancelling command. Press enter to continue..."
        fi
       read enterKey;;


    9)read -p "What would you like to update for user $email? Type either: [fullname, password, orgunit, suspend, hidegal] " updateuser
       if [ "$updateuser" = "fullname" ]; then
         read -p "Enter the first name to change user $email to: " update_firstname
         read -p "Enter the last name to change user $email to: " update_lastname
         gam update user $email firstname $update_firstname lastname $update_lastname
         echo "Done. $email has had their first name changed to $update_firstname and their last name changed to $update_lastname. Press the enter key to continue..."
       elif [ "$updateuser" = "password" ]; then
         read -p "Are you sure you want to change the password for $email? Type 1 for Yes, 2 for No: " update_password_confirm
          if [ $update_password_confirm -eq 1 ]; then
            read -p "Enter the new password to set for $email: " update_password
            gam update user $email password $update_password
            echo " $email password changed. Press the enter key to continue..."
          fi
       elif [ "$updateuser" = "orgunit" ]; then
         echo "Are you sure you want to change the organizational unit for $email?"
         read -p "Type 1 for Yes, 2 for No: " update_orgunit_confirm
          if [ $update_orgunit_confirm -eq 1 ]; then
            echo "Here is the list of all current Org Units in Moogsoft: "
            echo ""
            gam print orgs
            echo "For the next input, only input the name of the Org Unit."
            echo "AKA: Terminated Users, Mobile Device Management, etc..."
            read -p "Enter the new organizational unit to set for $email: " update_orgunit
            gam update user $email org "$update_orgunit"
            echo " $email org unit changed to $update_orgunit. Press the enter key to continue..."
          fi
       elif [ "$updateuser" = "suspend" ]; then
         echo "Do you want to suspend or unsuspend $email?"
         read -p "Type 1 for Suspend, 2 for Unsuspend: " suspend_confirm
          if [ $suspend_confirm -eq 1 ]; then
            gam update user $email suspended on
            echo "$email has been suspended. Press enter to continue..."
          elif [ $suspendconfirm -eq 2 ]; then
            gam update user $email suspended off
            echo "$email has been unsuspended. Press enter to continue..."
          fi
        elif [ "$updateuser" = "hidegal" ]; then
          echo "Are you sure you want to turn off Directory Sharing for $email?"
          read -p "Type 1 for Yes, 2 for No: " update_gal_confirm
           if [ $update_gal_confirm -eq 1 ]; then
             gam update user $email gal off
             echo " $email GAL (Directory Sharing) has been turned off. Press the enter key to continue..."
           fi
        fi
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
