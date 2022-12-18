


module core_vnet_deployment './module/vnet_deployment.bicep' = {
  name: 'test-fw-vn-deploy'
  params: {
    vnetname: 'test-fw-vn'
    vnetaddressprefix: '10.0.0.0/16'
    vnetlocation: 'northeurope'
    tagowner: 'robert mitchell'
    subnets:[
      {
        name: 'AzureFirewallSubnet'
        subnetprefix: '10.0.1.0/26'
      }
      {
        name: 'Workload-SN'
        subnetprefix: '10.0.2.0/24'
      }
    ]
  }
}

