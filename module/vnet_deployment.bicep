param vnetname string
param vnetaddressprefix string
param vnetlocation string
param tagowner string
param subnets array

resource coreservicesvnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: vnetname
  location:vnetlocation
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetaddressprefix
      ]
    }
    subnets: [for subnet in subnets: {
      name: subnet.name
      properties: {
        addressPrefix: subnet.subnetPrefix
      }
    }]
  }
  
  tags:{
    owner: tagowner
  }
  
  
}

output vnetnameforprivatedns string = coreservicesvnet.id

