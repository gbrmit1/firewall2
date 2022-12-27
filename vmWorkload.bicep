@description('Username for the Virtual Machine.')
param adminUsername string = 'firestarter21'

@secure()
param adminpassword string


param OSVersion string = '2019-Datacenter-smalldisk'
param vmSize string = 'Standard_D2s_v5'
param location string = 'northeurope'          // check this is correct
param vmName string = 'wl-vnet-vm' // unique value


var storageAccountName = 'bootdiagswl${uniqueString(resourceGroup().id)}'  // unique value less than 24 chars
var nicName = 'myVMNicWorkloadvm'

var networkSecurityGroupName = 'default-NSG-workload-vm'  // unique value

resource stg 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
}



resource securityGroup 'Microsoft.Network/networkSecurityGroups@2021-02-01' = {
  name: networkSecurityGroupName
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

//declarations for the nic
param vnetnameworkloadvnet string = 'test-fw-vn'   // declare the vnet to put the private NIC in - note existing
resource vnettodeploythenic 'Microsoft.Network/virtualNetworks@2022-07-01' existing = {
  name: vnetnameworkloadvnet
}
var subnetName = 'WorkloadSubnet' // declare the subnet name
///////////////////////////


resource nic 'Microsoft.Network/networkInterfaces@2021-02-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig2'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', vnettodeploythenic.name, subnetName)
          }
        }
      }
    ]
  }
}
output nicPrivateAddress string = nic.properties.ipConfigurations[0].properties.privateIPAddress

resource vm 'Microsoft.Compute/virtualMachines@2021-03-01' = {
  name: vmName
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: vmName
      adminUsername: adminUsername
      adminPassword: adminpassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks: [
        {
          diskSizeGB: 1023
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
        storageUri: stg.properties.primaryEndpoints.blob
      }
    }
    priority:'Spot'
    evictionPolicy:'Deallocate'
    billingProfile:{
      maxPrice:-1
    }
  }
}

