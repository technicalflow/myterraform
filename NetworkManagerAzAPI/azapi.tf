data "azurerm_client_config" "current" {}
data "azurerm_subscription" "sub" {}

### Network Manager
resource "azapi_resource" "vnetnm" {
  type      = "Microsoft.Network/networkManagers@2022-05-01"
  parent_id = azurerm_resource_group.rg300.id
  name      = "nm100"
  location  = azurerm_resource_group.rg300.location
  body = jsonencode({
    properties = {
      networkManagerScopeAccesses = ["Connectivity", "SecurityAdmin"]
      networkManagerScopes = {
        subscriptions = [data.azurerm_subscription.sub.id]
      }
    }
  })
}

### Network Group
resource "azapi_resource" "vnetnmng" {
  type      = "Microsoft.Network/networkManagers/networkGroups@2022-05-01"
  name      = "networkgroup1"
  parent_id = azapi_resource.vnetnm.id
  body = jsonencode({
    properties = {
      description = "NetworkGroup1"
    }
  })
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

### Network group members - add for_each
resource "azapi_resource" "ngmember1" {
  type      = "Microsoft.Network/networkManagers/networkGroups/staticMembers@2022-05-01"
  name      = "ng100"
  parent_id = azapi_resource.vnetnmng.id
  body = jsonencode({
    properties = {
      resourceId = azurerm_virtual_network.vnet[1].id
    }
  })
}

resource "azapi_resource" "ngmember2" {
  type      = "Microsoft.Network/networkManagers/networkGroups/staticMembers@2022-05-01"
  name      = "ng101"
  parent_id = azapi_resource.vnetnmng.id
  body = jsonencode({
    properties = {
      resourceId = azurerm_virtual_network.vnet[2].id
    }
  })
}

### Connectivity Configuration
resource "azapi_resource" "avnmconnectivity" {
  type      = "Microsoft.Network/networkManagers/connectivityConfigurations@2022-05-01"
  name      = "connectivity"
  parent_id = azapi_resource.vnetnm.id
  body = jsonencode({
    properties = {
      appliesToGroups = [
        {
          groupConnectivity = "DirectlyConnected"
          isGlobal          = "True" // In a sense that allow global communication between spokes
          networkGroupId    = azapi_resource.vnetnmng.id
          useHubGateway     = "False"
        }
      ]
      connectivityTopology  = "HubAndSpoke"
      deleteExistingPeering = "True"
      description           = "Connection Configuration"
      hubs = [
        {
          resourceId   = azurerm_virtual_network.vnet[0].id
          resourceType = "Microsoft.Network/virtualNetworks"
        }
      ]

      isGlobal = "False" //in a sense enable mesh global connectivity
    }
  })
}

### Security Admin Configuration
resource "azapi_resource" "avnmsc" {
  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations@2022-05-01"
  name      = "secconfig"
  parent_id = azapi_resource.vnetnm.id
  body = jsonencode({
    properties = {
      applyOnNetworkIntentPolicyBasedServices = ["AllowRulesOnly"] //All require subscription option registration - for now use AllowRulesOnly or None 
      description                             = "SecurityConfig"
    }
  })
}

### Create rule collection
resource "azapi_resource" "secrulecollection" {
  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections@2022-05-01"
  name      = "SecurityRuleCollection"
  parent_id = azapi_resource.avnmsc.id
  body = jsonencode({
    properties = {
      appliesToGroups = [
        {
          networkGroupId = azapi_resource.vnetnmng.id
        }
      ]
      description = "Security Rule Collection"
    }
  })
}

resource "azapi_resource" "securityrule" {
  type      = "Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules@2022-05-01"
  name      = "SSH_Access"
  parent_id = azapi_resource.secrulecollection.id
  body = jsonencode({
    name = "SSH_Access" // not required by Azure but terraform needs it
    kind = "Custom"     // Custom or default
    properties = {
      access                = "Allow" // In Azure called action - Allow, AlwaysAllow, Deny
      description           = "Allow SSH"
      destinationPortRanges = ["22"]
      destinations = [
        {
          addressPrefix     = "*"        // Destination address with Inbound connection does not need to be specified
          addressPrefixType = "IPPrefix" // Choose IPPrefix or ServiceTag
        }
      ]
      direction = "Inbound" //Inbound or Outbound
      priority  = 1001
      protocol  = "Tcp"
      sourcePortRanges = [
        "0-65535" // to allow all
      ]
      sources = [
        {
          addressPrefix     = "*"
          addressPrefixType = "IPPrefix" // Choose IPPrefix or ServiceTag
        }
      ]
    }
  })
}

### Not yet implemented - User Security Configuration
# resource "azapi_resource" "usersecconfig" {
#   name      = "usersecconfig"
#   parent_id = azapi_resource.vnetnm.id
#   type      = "Microsoft.Network/networkManagers/securityUserConfigurations@2022-04-01-preview"
#   body = jsonencode({
#     properties = {
#       deleteExistingNSGs = "True"
#       description        = "Security User Config"
#     }
#   })
# }

# resource "azapi_resource" "userrulecollection" {
#   name      = "userrulecollection"
#   parent_id = azapi_resource.usersecconfig.id
#   type      = "Microsoft.Network/networkManagers/securityUserConfigurations/ruleCollections@2022-04-01-preview"
#   body = jsonencode({
#     properties = {
#       appliesToGroups = [
#         {
#           networkGroupId = azapi_resource.vnetnmng.id
#         }
#       ]
#       description = "User Security Rule Collection"
#     }
#   })
# }

# resource "azapi_resource" "usersecrule" {
#   name      = "usersecrule"
#   parent_id = azapi_resource.userrulecollection.id
#   type      = "Microsoft.Network/networkManagers/securityUserConfigurations/ruleCollections/rules@2022-04-01-preview"
#   body = jsonencode({
#     name = "SSH_USER_Access" // not required by Azure but terraform needs it
#     kind = "Custom"          // Custom or default
#     properties = {
#       // No Access no Priority compared to Security Admin Rules
#       description           = "User Allow SSH"
#       destinationPortRanges = ["22"]
#       destinations = [
#         {
#           addressPrefix     = "*"        // Destination address with Inbound connection does not need to be specified
#           addressPrefixType = "IPPrefix" // Choose IPPrefix or ServiceTag
#         }
#       ]
#       direction = "Inbound" //Inbound or Outbound
#       protocol  = "Tcp"     //Accepted 'Ah' 'Any' 'Esp' 'Icmp' 'Tcp' 'Udp'      
#       sourcePortRanges = [
#         "0-65535" // to allow all
#       ]
#       sources = [
#         {
#           addressPrefix     = "*"
#           addressPrefixType = "IPPrefix" // Choose IPPrefix or ServiceTag
#         }
#       ]
#     }
#   })
# }

### Deployment using powershell
resource "null_resource" "initmodule" {
  provisioner "local-exec" {
    command     = "Install-module az && Install-Module -Name Az.Network -RequiredVersion 4.15.1-preview -AllowPrerelease"
    interpreter = ["pwsh", "-Command"]
    on_failure  = fail
  }
}

resource "null_resource" "pwshdeployconnectivity" {
  depends_on = [azapi_resource.avnmconnectivity]
  provisioner "local-exec" {
    command     = "Deploy-AzNetworkManagerCommit -Name ${azapi_resource.vnetnm.name} -ResourceGroupName ${azurerm_resource_group.rg300.name} -ConfigurationId ${azapi_resource.avnmconnectivity.id} -TargetLocation ${azurerm_resource_group.rg300.location} -CommitType 'Connectivity'"
    interpreter = ["pwsh", "-Command"]
    on_failure  = fail
  }
}

resource "null_resource" "pwshdeploysecurity" {
  depends_on = [azapi_resource.secrulecollection]
  provisioner "local-exec" {
    command     = "Deploy-AzNetworkManagerCommit -Name ${azapi_resource.vnetnm.name} -ResourceGroupName ${azurerm_resource_group.rg300.name} -ConfigurationId ${azapi_resource.avnmsc.id} -TargetLocation ${azurerm_resource_group.rg300.location} -CommitType 'Securityadmin'"
    interpreter = ["pwsh", "-Command"]
    on_failure  = fail
  }
}


### Simpler version of Security Rule
# resource "azapi_resource" "securityrule" {
#   type = "Microsoft.Network/networkManagers/securityAdminConfigurations/ruleCollections/rules@2022-05-01"
#   name = "SSH_Access"
#   parent_id = azapi_resource.secrulecollection.id
#   body = jsonencode({
#     name = "SSH_Access" // not required by Azure but terraform needs it
#     kind = "Custom"
#     properties = {
#       access = "Allow"
#       direction = "Inbound"
#       priority = 1002
#       protocol = "Tcp"

#     }
#   })
# }

# # For connecting two Network Managers
# resource "azapi_resource_action" "name" {
#   type = "Microsoft.Network/networkManagerConnections@2022-05-01"
#   body = jsonencode({
#     properties = {
#       description = ""
#       networkManagerId = ""
#     }
#   })
# }

# ## Cross tenant connections
# resource "azapi_resource" "avnmcrosstenantconnection" {
#   type = "Microsoft.Network/networkManagers/scopeConnections@2022-05-01"
#   parent_id = azapi_resource.vnetnm.id
#   name = "deploy1"
#   body = jsonencode({
#     properties = {
#         description = "Deploy Connectivity"
#         resourceId = ""
#         tenantId = ""
#     }
#   })
# }

# resource "azapi_resource_action" "name" {
#   type = "Microsoft.Network/networkManagers/networkGroups/staticMembers@2022-05-01"
# }
