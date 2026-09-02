resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = "dev"
    managed_by  = "terraform"
    deployed_by = "github-actions"
  }
}