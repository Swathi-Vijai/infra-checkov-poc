resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.rsgrp
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  account_kind             = "BlobStorage"
  
  tags = var.tags 
}

