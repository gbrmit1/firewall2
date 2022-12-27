param location string
param tagowner string
param publiciptier string
param publicIpAddressName string
param publicipallocationmethod string
param firewallpolicyname string
param firewallpolicysku string
param ipconfigurationname string
param firewallname string


//declarations for the firewall subnet used by the firewall resource
param vnetnamefirewallvnet string = 'test-fw-vn'   // declare the vnet to put the firewall in - note existing
resource vnettodeploythefw 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetnamefirewallvnet
}
var fwsubnetName = 'AzureFirewallSubnet' // declare the subnet name
///////////////////////////


resource firewallpublicip 'Microsoft.Network/publicIPAddresses@2022-07-01' = {
  name: publicIpAddressName
  location: location
  sku: {
    name:publiciptier
  }
  properties:{
    publicIPAllocationMethod: publicipallocationmethod
  }
  tags: {
    owner: tagowner
  }
}

resource firewallpolicy 'Microsoft.Network/firewallPolicies@2022-07-01' = {
  name: firewallpolicyname
  properties:{
    sku:{
      tier:firewallpolicysku
    }
  }
  location:location
  tags:{
    owner:tagowner
  }
}



resource firewall2 'Microsoft.Network/azureFirewalls@2022-07-01' = {
  name: firewallname
  location: location
  properties:{
    firewallPolicy:{
      id:firewallpolicy.id
    }
    ipConfigurations:[
      {
        name: ipconfigurationname
        properties:{
          publicIPAddress: {
            id:firewallpublicip.id
          }
          subnet:{
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnettodeploythefw.name,fwsubnetName)
          }
        }
      }
    ]
  }
}


