terraform {

  backend "azurerm" {

    

  }




  required_providers {

    azurerm = {

      source  = "hashicorp/azurerm"

      version = "~>2.0"

    }

    random = {

      source  = "hashicorp/random"

      version = "~>3.0"

    }

    tls = {

      source = "hashicorp/tls"

      version = "~>4.0"

    }

  }

}




provider "azurerm" {

  features {}

}







resource "azurerm_virtual_network" "secure_terraform_network" {

  name                = "secureVnet"

  address_space       = ["10.1.0.0/16"]

  location            = var.rg_location

  resource_group_name = var.rg_name

}




# Create subnet

resource "azurerm_subnet" "secure_terraform_subnet" {

  name                 = "secureSubnet"

  resource_group_name  = azurerm_virtual_network.secure_terraform_network.resource_group_name

  virtual_network_name = azurerm_virtual_network.secure_terraform_network.name

  address_prefixes     = ["10.1.1.0/24"]

}










variable "rg_location" {
  description = "The Azure location where to deploy your resources too"
  type        = string
  default     = "East US"
}




variable "rg_name" {
  description = "The Azure rg_name where to deploy your resources too"
  type        = string
  default     = "Devops-RG"
}







output "resource_group_name" {

  value = azurerm_virtual_network.secure_terraform_network.resource_group_name

}
