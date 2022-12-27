

@sys.batchSize(1)
module vnet_deployments './module/vnet_deployment.bicep' = {
  name: 'test-fw-vn-deploy'
  params: {
    vnetname: 'test-fw-vn'
    vnetaddressprefix: '10.0.0.0/16'
    vnetlocation: 'northeurope'
    tagowner: 'robert mitchell'
  }
}





