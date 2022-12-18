param localvnet string
resource localvnetpeer 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: localvnet
}

param vnettopeerwith string
resource vnettopeerto 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnettopeerwith
}

param vnetpeeringname string

resource vnetpeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2022-07-01' = {
  name: vnetpeeringname
  parent: localvnetpeer
  properties:{
    allowVirtualNetworkAccess:true
    allowForwardedTraffic:false
    allowGatewayTransit:false
    useRemoteGateways:false
    remoteVirtualNetwork:{
      id:resourceId('Microsoft.Network/virtualNetworks',vnettopeerto.name )
    }
  }
}
