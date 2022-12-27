resource firewallpolicy 'Microsoft.Network/firewallPolicies@2022-07-01' existing = {
  name: 'fw-policy'
}

resource firewallPublicIp 'Microsoft.Network/publicIPAddresses@2022-07-01' existing = {
  name: 'fw-pip'
}

resource vmNic 'Microsoft.Network/networkInterfaces@2022-07-01' existing = {
  name: 'myVMNicWorkloadvm'
}



resource networkRuleCollectionGroup 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2022-07-01' = {
  name: 'firewallPolicy'
  parent:firewallpolicy
  properties: {
    priority: 2000
    ruleCollections:[
      {
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        name: 'networkRule01'
        priority:2501
        rules:[
          {
            ruleType: 'NetworkRule'
            name: 'allow-wl-to-internet'
            ipProtocols:[
              'TCP'
            ]
            destinationAddresses:[
              '*'
            ]
            sourceAddresses:[
              '10.0.2.0/24'
            ]
            destinationPorts:[
              '53','443','80'
            ]
          }
        ]
      }
      {
        ruleCollectionType: 'FirewallPolicyNatRuleCollection'
        priority:2200
        action:{
          type:'DNAT'
        }
        name: 'dnatrule01'
        rules:[
          {
            description:'inbound-rdp-to-server'
            name:'inboundToServerRdp'
            ruleType:'NatRule'
            ipProtocols: [
              'TCP'
            ]
            destinationAddresses:[
              firewallPublicIp.properties.ipAddress
            ]
            destinationPorts:[
              '3389'
            ]
            sourceAddresses:[
              '*'
            ]
            translatedAddress: vmNic.properties.ipConfigurations[0].properties.privateIPAddress
            translatedPort:'3389'
          }
        ]
      }
    ]
  }

}

