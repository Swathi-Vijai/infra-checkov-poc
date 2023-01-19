terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.30.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "71ae4048-2e46-4255-8eca-c47663aa8f0c"
  tenant_id = "e714ef31-faab-41d2-9f1e-e6df4af16ab8"
  client_id = "b58a4c09-4fa6-4a55-bbfe-7a06baf30b5a"
  client_secret = "IY48Q~oiw~iPWPStohCxzjEpgNRW3dxZNUeCKbEI"
  features {}
}

locals {
  resource_group_name = "Devops-RG"
  location = "East US"

}

resource "azurerm_resource_group" "sai-rg" {
  name     = local.resource_group_name
  location = local.location
}


resource "azurerm_virtual_network" "sai-network" {
  name                = "sai-network"
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]
  depends_on = [
    azurerm_resource_group.sai-rg
  ]
}

resource "azurerm_subnet" "SubnetA" {
  name                 = "SubnetA"
  resource_group_name  = local.resource_group_name
  virtual_network_name = azurerm_virtual_network.sai-network.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_virtual_network.sai-network
  ]
}

resource "azurerm_network_interface" "sai-interface" {
  name                = "sai-interface"
  location            = local.location
  resource_group_name = local.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ip.id
  }
  depends_on = [
    azurerm_subnet.SubnetA
  ]
}

# resource "azurerm_public_ip" "ip" {
#   name                = "sai-PublicIp"
#   resource_group_name = local.resource_group_name
#   location            = local.location
#   allocation_method   = "Static"
#   depends_on = [
#     azurerm_resource_group.sai-rg
#   ]
# }

# resource "azurerm_network_security_group" "sai-nsg" {
#   name                = "sai-nsg"
#   location            = local.location
#   resource_group_name = local.resource_group_name
#   security_rule {
#     name                       = "AllowRDP"
#     priority                   = 300
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "3389"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
#   depends_on = [
#     azurerm_resource_group.sai-rg
#   ]
# }

# resource "azurerm_subnet_network_security_group_association" "sai-nsg-association" {
#   subnet_id                 = azurerm_subnet.SubnetA.id
#   network_security_group_id = azurerm_network_security_group.sai-nsg.id
# }

resource "azurerm_windows_virtual_machine" "sai-vm" {
  name                = "sai-vm"
  resource_group_name = local.resource_group_name
  location            = local.location
  size                = "Standard_D2s_v3"
  admin_username      = "sai-ch"
  admin_password      = "Azuresai@123"
  network_interface_ids = [
    azurerm_network_interface.sai-interface.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  depends_on = [
    azurerm_resource_group.sai-rg,
    azurerm_network_interface.sai-interface,
  ]
}
