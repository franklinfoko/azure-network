###########################
# Create a private DNS Zone
###########################
resource "azapi_resource" "privateDnsZone" {
  type      = "Microsoft.Network/privateDnsZones@2024-06-01"
  name      = "Contoso.com"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "global"
  tags      = var.tags
}

###########################################
# Task 2: Link subnet for auto registration
###########################################
resource "azapi_resource" "CoreServicesVnetLink" {
  type      = "Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01"
  name      = "CoreServicesVnetLink"
  parent_id = azapi_resource.privateDnsZone.id
  location  = "global"
  tags      = var.tags
  body = {
    properties = {
      registrationEnabled = true
      virtualNetwork = {
        id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/CoreServicesVnet"
      }
    }
  }
}

###########################################################
# Task 3: Create Virtual Machines to test the configuration
###########################################################
# vm1
resource "azapi_resource" "virtualMachine1" {
  type      = "Microsoft.Compute/virtualMachines@2026-04-01"
  name      = "virtualMachine1"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "East US"
  tags      = var.tags
  body = {
    properties = {
      hardwareProfile = {
        vmSize = "Standard_D2s_v6"
      }
      networkProfile = {
        networkInterfaces = [
          {
            id = azapi_resource.nic1.id
            properties = {
              primary = true
            }
          }
        ]
      }
      osProfile = {
        adminPassword = var.admin_password
        adminUsername = "azureuser"
        computerName  = "vm1"
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

resource "azapi_resource" "nic1" {
  type      = "Microsoft.Network/networkInterfaces@2025-09-01"
  name      = "nic1"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "East US"
  tags      = var.tags
  body = {
    properties = {
      ipConfigurations = [
        {
          name = "ipconfig1"
          properties = {
            privateIPAllocationMethod = "Dynamic"
            publicIPAddress = {
              id = azapi_resource.pip1.id
            }
            subnet = {
              id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/CoreServicesVnet/subnets/DatabaseSubnet"
            }
          }
        }
      ]
      networkSecurityGroup = {
        id = azapi_resource.nsg1.id
      }
    }
  }

  schema_validation_enabled = false
}

resource "azapi_resource" "nsg1" {
  type      = "Microsoft.Network/networkSecurityGroups@2025-09-01"
  name      = "nsg1"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "East US"
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

resource "azapi_resource" "pip1" {
  type      = "Microsoft.Network/publicIPAddresses@2025-09-01"
  name      = "pip1"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "East US"
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

# vm2
resource "azapi_resource" "virtualMachine2" {
  type      = "Microsoft.Compute/virtualMachines@2026-04-01"
  name      = "virtualMachine2"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "East US"
  tags      = var.tags
  body = {
    properties = {
      hardwareProfile = {
        vmSize = "Standard_D2s_v6"
      }
      networkProfile = {
        networkInterfaces = [
          {
            id = azapi_resource.nic2.id
            properties = {
              primary = true
            }
          }
        ]
      }
      osProfile = {
        adminPassword = var.admin_password
        adminUsername = "azureuser"
        computerName  = "vm2"
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

resource "azapi_resource" "nic2" {
  type      = "Microsoft.Network/networkInterfaces@2025-09-01"
  name      = "nic2"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "East US"
  tags      = var.tags
  body = {
    properties = {
      ipConfigurations = [
        {
          name = "ipconfig1"
          properties = {
            privateIPAllocationMethod = "Dynamic"
            publicIPAddress = {
              id = azapi_resource.pip2.id
            }
            subnet = {
              id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/virtualNetworks/CoreServicesVnet/subnets/DatabaseSubnet"
            }
          }
        }
      ]
      networkSecurityGroup = {
        id = azapi_resource.nsg2.id
      }
    }
  }

  schema_validation_enabled = false
}

resource "azapi_resource" "nsg2" {
  type      = "Microsoft.Network/networkSecurityGroups@2025-09-01"
  name      = "nsg2"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "East US"
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

resource "azapi_resource" "pip2" {
  type      = "Microsoft.Network/publicIPAddresses@2025-09-01"
  name      = "pip2"
  parent_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  location  = "East US"
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
