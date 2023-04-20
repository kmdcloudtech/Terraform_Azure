/*
to destroy >> terraform destroy 
it will give error 
Error: Instance can not be destroyed
we can use target flag directly
terraform destroy --target=azurerm_virtual_network.myvnet
*/


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
            lifecycle {
              prevent_destroy = true
            }
}
# virtual network 
resource "azurerm_virtual_network" "myvnet" {
    name = "myvnet-1"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.demoRG.location 
    resource_group_name = azurerm_resource_group.demoRG.name 
  
}

