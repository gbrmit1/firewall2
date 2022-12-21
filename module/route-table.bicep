
param routetables array
param location string

resource routetable 'Microsoft.Network/routeTables@2022-07-01' = [for routeTable in routetables:{
  name:routeTable.name
  location:location
  properties:{
    disableBgpRoutePropagation:true
    routes:routeTable.routes
  }
} ]
