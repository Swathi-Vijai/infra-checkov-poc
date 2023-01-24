terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.30.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

resource "azurerm_resource_group" "sai-rg" {
    name = "Devops-RG"
    location = "East US"
}


resource "azurerm_storage_account" "example" {
  name                     = "sai-ch-storage"
  resource_group_name      = "Devops-RG"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "BlobStorage"
  depends_on = [
    azurerm_resource_group.sai-rg
  ]
}

resource "azurerm_storage_container" "example" {
  name                  = "data"
  storage_account_name  = "sai-ch-storage"
  container_access_type = "blob"
  depends_on = [
    azurerm_storage_account.example
  ]
}

resource "azurerm_storage_blob" "example" {
  name                   = "main.tf"
  storage_account_name   = "sai-ch-storage"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "main.tf"
  depends_on = [
    azurerm_storage_container.example
  ]
}