var wlsubnets = [
  {
    name: 'WorkloadSubnet'
    subnetPrefix:'10.0.2.0/24'
  }
  {
    name: 'WorkloadSubnet3'
    subnetPrefix:'10.0.3.0/24'
  }
  {
    name: 'WorkloadSubnet4'
    subnetPrefix:'10.0.4.0/24'
  }
  {
    name: 'WorkloadSubnet5'
    subnetPrefix:'10.0.5.0/24'
  }
  {
    name: 'WorkloadSubnet6'
    subnetPrefix:'10.0.6.0/24'
  }
  {
    name: 'WorkloadSubnet7'
    subnetPrefix:'10.0.7.0/24'
  }
  {
    name: 'WorkloadSubnet8'
    subnetPrefix:'10.0.8.0/24'
  }
]

var fwsubnet = [
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

resource WlSubnets 'Microsoft.Network/virtualNetworks/subnets@2022-07-01'= [for sn in wlsubnets: {
  name:sn.name
  parent:vnet
  properties:{
    addressPrefix:sn.subnetPrefix
    routeTable:{
      id: routetable.id
    }
  }
  
}]

resource FwSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-07-01'= [for sn in fwsubnet: {
  name:sn.name
  dependsOn:WlSubnets
  parent:vnet
  properties:{
    addressPrefix:sn.subnetPrefix
  }
}]
