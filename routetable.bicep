var routeTables = [
  {
    name: 'wlRouteTable'
    routes:[
      {
        name: 'defaultRoute'
        properties:{
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress:wlrtNextHop
        }
      }
    ]
    tags:{
      owner:'robert mitchell routes'
    }
  }
]

param location string
param wlrtNextHop string


module routes './module/route-table.bicep' = {
  name:'routes'
  params:{
    routetables:routeTables
    location:location
  }
}






