# Create Resource group,Vnet,subnet,NIC card manually 
# get subent id from this command 
# az network vnet subnet list -g MyResourceGroup --vnet-name MyVNet   

terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.33.0"
    }
  }
}
# Provider Block

provider "azurerm" {
    features {}
    subscription_id = "0d70d1de-5b9f-42a5-af26-74db6cc6ef60"
    }
resource "azurerm_resource_group" "demoRG" {   # Reference Name
            name = "demoRG"
            location = "Central India"
            tags = {
              "Team" = "Dev"
              "Owner" = "Sudheer"
            }

}
resource "azurerm_network_interface" "example" {
    name = "example-nic"
    location = "Central India"
    resource_group_name = azurerm_resource_group.demoRG.name

    ip_configuration {
      name = "internal"
      subnet_id = "/subscriptions/0d70d1de-5b9f-42a5-af26-74db6cc6ef60/resourceGroups/demoRG/providers/Microsoft.Network/virtualNetworks/myvnet/subnets/default"
      private_ip_address_allocation = "Dynamic"
    }

  
}
resource "azurerm_linux_virtual_machine" "example" {
  name = "example"
  resource_group_name = azurerm_resource_group.demoRG.name
  location = "Central India"
  size = "Standard_F2"
  admin_username = "cloud"
  admin_password = "Azure@123"
  disable_password_authentication =  false
  network_interface_ids = [azurerm_network_interface.example.id,]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
  }
}


# terraform init 
# terraform plan 
# terraform apply 
# terraform destroy 
