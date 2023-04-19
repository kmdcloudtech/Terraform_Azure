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
    
# code for Resource Group 
resource "azurerm_resource_group" "demoRG" {   # Reference Name
            name = "demoRG-${count.index}"
            location = "Central India"
            count = 2
            tags = {
              "Team" = "Dev"
              "Owner" = "Sudheer"
            }

}
# code for virtual network 
resource "azurerm_virtual_network" "myvnet" {
    name = "myvnet-${count.index}"
    count = 2 
    address_space = ["10.0.0.0/16"]
    location = element(azurerm_resource_group.demoRG[*].location,count.index) 
    resource_group_name = element(azurerm_resource_group.demoRG[*].name,count.index)
  
}
# code for subnet
resource "azurerm_subnet" "mysubent" {
    name = "mysubnet-${count.index}"
    count = 2
    resource_group_name = element(azurerm_resource_group.demoRG[*].name,count.index)
    virtual_network_name = element(azurerm_virtual_network.myvnet[*].name,count.index)
    address_prefixes = ["10.0.0.0/24"]

}
# code for public ip
resource "azurerm_public_ip" "mypublicip" {
    name = "mypublicip-${count.index}"
    count = 2 
    resource_group_name = element(azurerm_resource_group.demoRG[*].name,count.index)
    location = element(azurerm_resource_group.demoRG[*].location,count.index)
    allocation_method = "Static"
    tags = {
      "team" = "dev"
    }
  
}
# code for  NIC 
resource "azurerm_network_interface" "myvmnic" {
    name = "vmnic-${count.index}"
    count = 2
    location = element(azurerm_resource_group.demoRG[*].location,count.index)
    resource_group_name = element(azurerm_resource_group.demoRG[*].name,count.index)
    ip_configuration {
      name = "internal"
      subnet_id = element(azurerm_subnet.mysubent[*].id,count.index) 
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = element(azurerm_public_ip.mypublicip[*].id,count.index)
    }
}
# code for virtual machine
resource "azurerm_linux_virtual_machine" "mylinuxvm" {
  name = "mylinxvm-${count.index}"
  count = 2
  resource_group_name = element(azurerm_resource_group.demoRG[*].name,count.index)
  location = "Central India"
  size = "Standard_F2"
  admin_username = "cloud"
  admin_password = "Azure@123"
  disable_password_authentication =  false
  network_interface_ids = [element(azurerm_network_interface.myvmnic[*].id,count.index)]
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

/*
In Terraform, an "element" typically refers to a single item in a list or map variable.
Lists and maps are used to group related values together and can be defined in Terraform configuration files using the list and map data types respectively. Each element in a list or map is identified by its index or key respectively.
*/
