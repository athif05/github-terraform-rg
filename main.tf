resource "azurerm_resource_group" "example" {
  for_each = toset(var.resource_group_name)
  name     = each.key
  location = var.location

  tags = {
    environment = "dev"
    managed_by  = "terraform"
    deployed_by = "github-actions"
  }
}