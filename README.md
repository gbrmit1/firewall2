"# firewall2" 
Working Firewall deployment with Public Address which allows inbound to the VM through the Public address of the Firewall.

Deployment scripts

#!/bin/bash
az group create --location northeurope --resource-group rm-bicep-test
az deployment group create --resource-group rm-bicep-test --template-file routetable.bicep --parameters @parameters/routetable.parameters.json
az deployment group create --resource-group rm-bicep-test --template-file vnet.bicep
#
az keyvault create --name robertmitchell212121 --resource-group rm-bicep-test --location northeurope --enabled-for-template-deployment true
az keyvault secret set --vault-name robertmitchell212121 --name "wlPassword" --value "B0llock212121"
#
az deployment group create --resource-group rm-bicep-test --template-file subnets.bicep
az deployment group create --resource-group rm-bicep-test --template-file firewall2.bicep --parameters @parameters/firewall2.parameters.json
az deployment group create --resource-group rm-bicep-test --template-file vmWorkload.bicep --parameters @parameters/vmWorkload.parameters.json
az deployment group create --resource-group rm-bicep-test --template-file firewallRules.bicep


#!/bin/bash
az group delete -n rm-bicep-test -y
