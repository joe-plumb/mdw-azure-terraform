#!/bin/sh
# Note: Requires Azure CLI >= 2.6.0
# see: https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-directory-file-acl-cli

# Query
printf "Query container state..."
AZ_RESPONSE=$(az storage fs exists \
  -n "$CONTAINER_NAME" \
  --account-key "$STORAGE_ACCOUNT_KEY" \
  --account-name "$STORAGE_ACCOUNT_NAME" \
  --query "exists" 2>&1)
printf "\n\nResponse:\n\n%s\n\n" "$AZ_RESPONSE"

# Parse response
if [ "$AZ_RESPONSE" = "true" ]; then
  AZ_CONTAINER_EXISTS=1
else
  AZ_CONTAINER_EXISTS=0
fi
printf "Exists: %d\n" "$AZ_CONTAINER_EXISTS"

# Create if missing
if [ "$AZ_CONTAINER_EXISTS" -eq "0" ]; then
  printf "\nCreate container: %s" "$CONTAINER_NAME"
  AZ_RESPONSE=$(az storage fs create \
    -n "$CONTAINER_NAME" \
    --account-key "$STORAGE_ACCOUNT_KEY" \
    --account-name "$STORAGE_ACCOUNT_NAME" \
    --public-access off \
    2>&1)
  printf "\n\nResponse:\n\n%s\n\n" "$AZ_RESPONSE"
else 
  printf "\nContainer exists. No action."

fi