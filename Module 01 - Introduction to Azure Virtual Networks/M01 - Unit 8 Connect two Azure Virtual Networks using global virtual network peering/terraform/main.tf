############################################################
# Task 1: Create a Virtual Machine to test the configuration
############################################################
resource "azapi_resource" "ManufacturingVM" {
  type      = "Microsoft.Compute/virtualMachines@2026-04-01"
  name      = "ManufacturingVM"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "West Europe "
  tags      = var.tags
  body = {
    properties = {
      hardwareProfile = {
        vmSize = "Standard_D2s_v6"
      }
      networkProfile = {
        networkInterfaces = [
          {
            id = azapi_resource.ManufacturingVMnic.id
            properties = {
              primary = true
            }
          }
        ]
      }
      osProfile = {
        adminPassword = var.admin_password
        adminUsername = "azureuser"
        computerName  = "ManufacturingVM"
        windowsConfiguration = {
          provisionVMAgent = true
        }
      }
      storageProfile = {
        dataDisks = []
        imageReference = {
          offer     = "WindowsServer"
          publisher = "MicrosoftWindowsServer"
          sku       = "2022-datacenter-g2"
          version   = "latest"
        }
        osDisk = {
          createOption = "FromImage"
        }
      }
    }
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "ManufacturingVMnic" {
  type      = "Microsoft.Network/networkInterfaces@2025-09-01"
  name      = "ManufacturingVMnic"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "West Europe "
  tags      = var.tags
  body = {
    properties = {
      ipConfigurations = [
        {
          name = "ipconfig1"
          properties = {
            privateIPAllocationMethod = "Dynamic"
            publicIPAddress = {
              id = azapi_resource.ManufacturingVMpip.id
            }
            subnet = {
              id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/ManufacturingVnet/subnets/ManufacturingSystemSubnet"
            }
          }
        }
      ]
      networkSecurityGroup = {
        id = azapi_resource.ManufacturingVMnsg.id
      }
    }
  }

  schema_validation_enabled = false
}

resource "azapi_resource" "ManufacturingVMnsg" {
  type      = "Microsoft.Network/networkSecurityGroups@2025-09-01"
  name      = "ManufacturingVMnsg"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "West Europe"
  tags      = var.tags
  body = {
    properties = {
      securityRules = [
        {
          name = "default-allow-rdp"
          properties = {
            access                   = "Allow"
            destinationAddressPrefix = "*"
            destinationPortRange     = "3389"
            direction                = "Inbound"
            priority                 = 1000
            protocol                 = "Tcp"
            sourceAddressPrefix      = "*"
            sourcePortRange          = "*"
          }
        }
      ]
    }
  }

  schema_validation_enabled = false
}

resource "azapi_resource" "ManufacturingVMpip" {
  type      = "Microsoft.Network/publicIPAddresses@2025-09-01"
  name      = "ManufacturingVMpip"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "West Europe"
  tags      = var.tags
  body = {
    properties = {
      publicIPAddressVersion   = "IPv4"
      publicIPAllocationMethod = "Static"
    }
    sku = {
      name = "Standard"
      tier = "Regional"
    }
  }

  schema_validation_enabled = false
}

#############################################################################
# Task 4: Create VNet peerings between CoreServicesVnet and ManufacturingVnet
#############################################################################
locals {
  core_services_vnet_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/CoreServicesVnet"
  manufacturing_vnet_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/ManufacturingVnet"
}

# CoreServicesVnet (East US) -> ManufacturingVnet (West Europe)
resource "azapi_resource" "CoreServicesToManufacturing" {
  type      = "Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-09-01"
  name      = "CoreServicesVnet-to-ManufacturingVnet"
  parent_id = local.core_services_vnet_id
  body = {
    properties = {
      allowVirtualNetworkAccess = true
      allowForwardedTraffic     = true
      allowGatewayTransit       = false
      useRemoteGateways         = false
      remoteVirtualNetwork = {
        id = local.manufacturing_vnet_id
      }
    }
  }

  schema_validation_enabled = false
}

# ManufacturingVnet (West Europe) -> CoreServicesVnet (East US)
resource "azapi_resource" "ManufacturingToCoreServices" {
  type      = "Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-09-01"
  name      = "ManufacturingVnet-to-CoreServicesVnet"
  parent_id = local.manufacturing_vnet_id
  body = {
    properties = {
      allowVirtualNetworkAccess = true
      allowForwardedTraffic     = true
      allowGatewayTransit       = false
      useRemoteGateways         = false
      remoteVirtualNetwork = {
        id = local.core_services_vnet_id
      }
    }
  }

  schema_validation_enabled = false
}
