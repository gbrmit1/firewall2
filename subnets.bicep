var subnets = [
  {
    name: 'WorkloadSubnet'
    subnetPrefix:'10.0.2.0/24'
  }
]

var subnets2 = [
  {
    name:'AzureFirewallSubnet'
    subnetPrefix:'10.0.1.0/26'
  }
]

resource vnet 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: 'test-fw-vn'
}

resource routetable 'Microsoft.Network/routeTables@2022-07-01' existing = {
  name:'wlRouteTable'
}

@batchSize(1)

resource Subnets 'Microsoft.Network/virtualNetworks/subnets@2022-07-01'= [for sn in subnets: {
  name:sn.name
  parent:vnet
  properties:{
    addressPrefix:sn.subnetPrefix
    routeTable:{
      id: routetable.id
    }
  }
  
}]

resource Subnets2 'Microsoft.Network/virtualNetworks/subnets@2022-07-01'= [for sn in subnets2: {
  name:sn.name
  dependsOn:Subnets
  parent:vnet
  properties:{
    addressPrefix:sn.subnetPrefix
  }
}]
