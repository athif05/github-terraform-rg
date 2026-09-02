subscription_id = "b86827db-a6c0-4a92-9b6a-605192a2bc44"

resource_group_name = "mera_group"

vnet_name          = "vnet-terraform"
vnet_address_space = ["10.0.0.0/16"]

subnet_name             = "subnet-vm"
subnet_address_prefixes = ["10.0.1.0/24"]

nic_name       = "nic-terraform-vm"
public_ip_name = "pip-terraform-vm"
nsg_name       = "nsg-terraform-vm"

vm_name = "vm-terraform"
vm_size = "Standard_B2s"

admin_username = "azureadmin"
admin_password = "azure@05Admin"