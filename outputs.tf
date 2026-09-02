# /* output "resource_group_name" {
#   value = azurerm_resource_group.example.name
# }

# output "resource_group_id" {
#   value = azurerm_resource_group.example.id
# } */
output "resource_group_name" {
  value = azurerm_resource_group.example.name
}

output "vm_name" {
  value = azurerm_linux_virtual_machine.example.name
}

output "vm_private_ip" {
  value = azurerm_network_interface.example.private_ip_address
}

output "vm_public_ip" {
  value = azurerm_public_ip.example.ip_address
}

output "vnet_name" {
  value = azurerm_virtual_network.example.name
}

output "subnet_name" {
  value = azurerm_subnet.example.name
}

output "nic_name" {
  value = azurerm_network_interface.example.name
}