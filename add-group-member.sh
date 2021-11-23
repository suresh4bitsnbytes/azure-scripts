#!/bin/bash

# Receive group name and user email as arguments
while getopts "g:e:" arg; do
  case "${arg}" in
        g) 
          group_name=${OPTARG}
          ;;
        e)
          user_email=${OPTARG}
          ;;
  esac
done

user_id=$(az ad user list --query "[?mail=='$user_email']".{objectId:objectId}[0].objectId -o json)
# remove double quotes
user_id=`sed -e 's/^"//' -e 's/"$//' <<<"$user_id"`
 
if [ -z "$user_id" ];
  then
    echo "User with email id $user_email not found."
  else
    is_member_already=$(az ad group member check --group $group_name --member-id $user_id --query value)
    if [ "$is_member_already" = false ];
      then
        az ad group member add --group $group_name --member-id $user_id
        echo "User with email id:$user_email added as a member of the group:$group_name"
      else
        echo "User with email id:$user_email is already a member of the group:$group_name"
    fi
fi
