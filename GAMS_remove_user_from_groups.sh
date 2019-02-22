#! /bin/bash

gam() { "/Users/joey.wu/bin/gam/gam" "$@" ; }

mooguser(){
  echo "You are now using GAMS to administrate the Moogsoft G Suite Instance. Pleaes be careful"
  read -p "Enter email address to make changes to: " email
    if [[ -z $email ]];
      then echo "Please enter an email address to proceed";
      read -p "Enter email address to make changes to: " email
    fi
}

clear
mooguser
while :
do
  clear
  echo "Currently managing $email"
  echo "1. Remove user from All Groups"
  echo "2. Remove user from One Group"
    read opt
    case $opt in
      1)echo "************ Remove From All Groups ************";
        purge_groups=$($gam info user $email | grep -A 100 "Groups:" |cut -d '<' -f2 |cut -d '>' -f1 |grep -v 'Groups:')
           for i in $purge_groups
            do
               echo removing $i
               $gam update group $i remove member $email
            done;
        echo "All groups removed press [enter] key to continue. . .";
        read enterKey;;

      2)echo "************ Remove From One Group ************";
        read -p "Enter Group name to be removed " group_name
        $gam update group $group_name remove owner $email
        $gam update group $group_name remove member $email
        echo "Group has been removed press [enter] key to continue. . .";
        read enterKey;;

      *) echo "$opt is an invaild option. Please select option between 1-15 only"
         echo "Press [enter] key to continue. . .";
          read enterKey;;
  esac
  done
