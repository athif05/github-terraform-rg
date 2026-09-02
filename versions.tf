terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    resource_group_name = "rg-for-tfstate"
    storage_account_name = "athifstorageaccount"
    container_name = "my-tfstate-file"
    key = "my-tfstate"
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}