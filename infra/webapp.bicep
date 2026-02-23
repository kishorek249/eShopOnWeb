param webAppName string // = uniqueString(resourceGroup().id) // unique String gets created from az cli instructions
param sku string = 'S1' // The SKU of App Service Plan
param location string = resourceGroup().location

var appServicePlanName = toLower('AppServicePlan-${webAppName}')
var skuMap = {
  'F1': { name: 'f1', tier: 'Free' }
  'B1': { name: 'b1', tier: 'Basic' }
  'S1': { name: 's1', tier: 'Standard' }
  'S2': { name: 's2', tier: 'Standard' }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  properties: {
    reserved: true
  }
  sku: {
    name: skuMap[sku].name
    tier: skuMap[sku].tier
  }
}
resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  kind: 'app'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|8.0'
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
        {
          name: 'UseOnlyInMemoryDatabase'
          value: 'true'
        }
      ]
    }
  }
}
