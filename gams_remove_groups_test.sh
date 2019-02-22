#!/bin/bash

gam() { "/Users/joey.wu/bin/gam/gam" "$@" ; }

echo Enter the email address to administrate:

read email

echo Administrating $email...

while :
do
  clear
  echo "What would you like to do?"
  echo "1. Delete user from a group"
  echo "2. Delete user from all groups"
  echo "3. Add User to Group"
  echo "4. Transfer Drive resources to another user"
  echo "5. Undelete a user"
  echo "6. Create a Google Group"
  echo "7. Delete a Google Group"
  echo "8. Get User Information"
  echo "9. Check if Email Address is User, Group, or Alias"
  echo "10. Delete User"
  echo "11. Create User $email"


  read opt
  case $opt in
    1)read -p "Enter the group email address to edit: " groupemail
      echo "Editing $groupemail..."
      gam update group $groupemail remove user $email
      echo "User deleted from group. Press the enter key to continue"
      read enterKey;;

    2)echo "Deleting user from all Groups"
      gam user $email delete Groups
      echo "User deleted from all groups. Press the enter key to continue"
      read enterKey;;

    3)read -p "Enter the group email address to add $email to: " addtogroup
      gam update group $addtogroup add member $email
      echo "Completed. Press the enter key to continue"
      read enterKey;;

    4)read -p "Enter the email address to transfer files TO: " driveemail
      echo "Transferring Drive files to $driveemail..."
      gam user $email transfer drive $driveemail
      echo "Files transferred. Press the enter key to continue"
      read enterKey;;

    5)#read -p "Enter the email address of the user to undelete (Note: This will only undelete users that were deleted within the past 5 days): " undeleteuser
      echo "Restoring $email..."
      gam undelete user $email
      echo "User undeleted. Press the enter key to continue"
      read enterKey;;

    6)read -p "Enter the email address of the new group you would like to create: " $creategroup
      echo "Creating group $creategroup..."
      gam create group $creategroup
      echo "Group created. Press the enter key to continue"
      read enterKey;;

    7)read -p "Enter the email address of the group you would like to delete: " $deletegroup
      echo "Deleting group $deletegroup..."
      gam delete group $deletegroup
      echo "Group deleted. Press the enter key to continue"
      read enterKey;;

    8)echo "Getting information for $email..."
      gam info user $email
      read enterKey;;

    9)echo "Getting information for $email..."
      gam whatis $email
      read enterKey;;

    10)echo "Deleting user $email..."
       gam delete user $email
       echo "User deleted. Press the enter key to continue"
       read enterKey;;

    11)read -p "Enter the first name of the user: " first_name
       read -p "Enter the last name of the user: " last_name
       echo "Creating user $email..."
       gam create user $email firstname "$first_name" lastname "$last_name"
       echo "User $email created. Press the enter key to continue"
       read enterKey;;
  esac
done

echo Done!
read enterKey;;
