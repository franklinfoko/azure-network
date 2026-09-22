########################################### 
# Task 1: Create the Contoso resource group
###########################################
resource "azapi_resource" "resourceGroup" {
  type     = "Microsoft.Resources/resourceGroups@2025-04-01"
  name     = var.resource_group_name
  location = "East US"
  tags     = var.tags
}

#################################################################
# Task 2: Create the CoreServicesVnet virtual network and subnets
#################################################################
resource "azapi_resource" "CoreServicesVnet" {
  type      = "Microsoft.Network/virtualNetworks@2025-07-01"
  name      = "CoreServicesVnet"
  parent_id = azapi_resource.resourceGroup.id
  location  = "East US"
  tags      = var.tags
  body = {
    properties = {
      addressSpace = {
        addressPrefixes = [
          "10.20.0.0/16"
        ]
      }
    }
  }
}

resource "azapi_resource" "GatewaySubnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2025-09-01"
  name      = "GatewaySubnet"
  parent_id = azapi_resource.CoreServicesVnet.id
  body = {
    properties = {
      addressPrefix = "10.20.0.0/27"
    }
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "SharedServicesSubnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2025-09-01"
  name      = "SharedServicesSubnet"
  parent_id = azapi_resource.CoreServicesVnet.id
  body = {
    properties = {
      addressPrefix = "10.20.10.0/24"
    }
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "DatabaseSubnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2025-09-01"
  name      = "DatabaseSubnet"
  parent_id = azapi_resource.CoreServicesVnet.id
  body = {
    properties = {
      addressPrefix = "10.20.20.0/24"
    }
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "PublicWebServiceSubnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2025-09-01"
  name      = "PublicWebServiceSubnet"
  parent_id = azapi_resource.CoreServicesVnet.id
  body = {
    properties = {
      addressPrefix = "10.20.30.0/24"
    }
  }
  schema_validation_enabled = false
}

##################################################################
# Task 3: Create the ManufacturingVnet virtual network and subnets
##################################################################
resource "azapi_resource" "ManufacturingVnet" {
  type      = "Microsoft.Network/virtualNetworks@2025-07-01"
  name      = "ManufacturingVnet"
  parent_id = azapi_resource.resourceGroup.id
  location  = "West Europe"
  tags      = var.tags
  body = {
    properties = {
      addressSpace = {
        addressPrefixes = [
          "10.30.0.0/16"
        ]
      }
    }
  }
}

resource "azapi_resource" "ManufacturingSystemSubnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2025-09-01"
  name      = "ManufacturingSystemSubnet"
  parent_id = azapi_resource.ManufacturingVnet.id
  body = {
    properties = {
      addressPrefix = "10.30.10.0/24"
    }
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "SensorSubnet1" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2025-09-01"
  name      = "SensorSubnet1"
  parent_id = azapi_resource.ManufacturingVnet.id
  body = {
    properties = {
      addressPrefix = "10.30.20.0/24"
    }
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "SensorSubnet2" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2025-09-01"
  name      = "SensorSubnet2"
  parent_id = azapi_resource.ManufacturingVnet.id
  body = {
    properties = {
      addressPrefix = "10.30.21.0/24"
    }
  }
  schema_validation_enabled = false
}

resource "azapi_resource" "SensorSubnet3" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2025-09-01"
  name      = "SensorSubnet3"
  parent_id = azapi_resource.ManufacturingVnet.id
  body = {
    properties = {
      addressPrefix = "10.30.22.0/24"
    }
  }
  schema_validation_enabled = false
}

#############################################################
# Task 4: Create the ResearchVnet virtual network and subnets
#############################################################
resource "azapi_resource" "ResearchVnet" {
  type      = "Microsoft.Network/virtualNetworks@2025-07-01"
  name      = "ResearchVnet"
  parent_id = azapi_resource.resourceGroup.id
  location  = "Southeast Asia"
  tags      = var.tags
  body = {
    properties = {
      addressSpace = {
        addressPrefixes = [
          "10.40.0.0/16"
        ]
      }
    }
  }
}

resource "azapi_resource" "ResearchSystemSubnet" {
  type      = "Microsoft.Network/virtualNetworks/subnets@2025-09-01"
  name      = "ResearchSystemSubnet"
  parent_id = azapi_resource.ResearchVnet.id
  body = {
    properties = {
      addressPrefix = "10.40.0.0/24"
    }
  }
  schema_validation_enabled = false
}