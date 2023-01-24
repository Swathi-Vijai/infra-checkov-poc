resource "azurerm_storage_account" "vmstore4577" {
  name                     = "vmstore4577"
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"  
  depends_on = [
    azurerm_resource_group.appgrp
  ]
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = "vmstore4577"
  container_access_type = "blob"
  depends_on=[
    azurerm_storage_account.vmstore4577
    ]
}

resource "azurerm_storage_blob" "IISConfig" {
  name                   = "IIS_Config.ps1"
  storage_account_name   = "vmstore4577"
  storage_container_name = "data"
  type                   = "Block"
  source                 = "IIS_Config.ps1"
   depends_on=[azurerm_storage_container.data,
    azurerm_storage_account.vmstore4577]
}


resource "azurerm_virtual_machine_extension" "vmextension" {
  count=  var.number_of_machines
  name                 = "appvm-extension${count.index}"
  virtual_machine_id   = azurerm_windows_virtual_machine.appvm[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.10"
  depends_on = [
    azurerm_storage_blob.IISConfig
  ]
  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.vmstore4577.name}.blob.core.windows.net/data/IIS_Config.ps1"],
          "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file IIS_Config.ps1"     
    }
SETTINGS

}
