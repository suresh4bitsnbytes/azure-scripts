#!/bin/bash

# Receive group name and user email as arguments
while getopts "g:e:" arg; do
  case "${arg}" in
        g) 
          group_name=${OPTARG}
          ;;
        e)
          owner_email=${OPTARG}
          ;;
  esac
done

user_id=$(az ad user list --query "[?mail=='$owner_email']".{objectId:objectId}[0].objectId -o json)
# remove double quotes
user_id=`sed -e 's/^"//' -e 's/"$//' <<<"$user_id"`
echo $user_id
if [ -z "$user_id" ];
  then
    echo "User with email id $owner_email not found."
  else:
    az ad group owner add --group $group_name --owner-object-id $user_id
    echo "User with email id:$owner_email added as a owner to the group:$group_name"
fi
