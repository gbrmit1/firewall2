var routeTables = [
  {
    name: 'wlRouteTable'
    routes:[
      {
        name: 'defaultRoute'
        properties:{
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress:'10.0.1.4'
        }
      }
    ]
    tags:{
      owner:'robert mitchell routes'
    }
  }
]

param location string = 'northeurope'



module routes './module/route-table.bicep' = {
  name:'routes'
  params:{
    routetables:routeTables
    location:location
  }
}






