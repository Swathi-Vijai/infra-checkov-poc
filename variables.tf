variable "rsgrp" {
  type        = string
  description = "Name of the resource group"
  default     = "devops-rg"
}

variable "location" {
  type        = string
  description = "Location for deploying resources"
  default     = "eastus"
}
variable "storage_account_name" {
  type = string
  description = "This variable defines storage account name"
}


variable "tags" {
  type = object({
    created_by       = string
    created_for      = string
    
  })
}
