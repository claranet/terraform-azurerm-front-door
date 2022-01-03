#!/bin.bash

# Location is a mandatory parameter but FrontDoor service is global, so "westeurope" is not used here but mandatory ¯\_(ツ)_/¯
PREFIXES=$(az network list-service-tags --location westeurope --query "values[?properties.systemService=='AzureFrontDoor'].properties | [0].addressPrefixes" -o json)

jq -n --arg prefixes "$PREFIXES" '{"addressPrefixes":$prefixes}'
