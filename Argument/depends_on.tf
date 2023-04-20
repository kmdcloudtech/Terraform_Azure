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
# virtual network 
resource "azurerm_virtual_network" "myvnet" {
    name = "myvnet-1"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.demoRG.location 
    resource_group_name = azurerm_resource_group.demoRG.name 
  
}
# subnet
resource "azurerm_subnet" "mysubnet" {
    name = "mysubnet-1"
    resource_group_name = azurerm_resource_group.demoRG.name 
    virtual_network_name = azurerm_virtual_network.myvnet.name
    address_prefixes = ["10.0.0.0/24"]

}
# Create Public IP with Explicit Dependency 
resource "azurerm_public_ip" "mypublicip" {
     # Add Explicit Dependency to have this resource created only after Virtual Network and Subnet Resources are created
     /*
     depends_on = [
        azurerm_virtual_network.myvnet,
        azurerm_subnet.mysubnet       
     ] 
     */ 

     name           =   "mypublicip-1"
     resource_group_name = azurerm_resource_group.demoRG.name
     location = azurerm_resource_group.demoRG.location
     allocation_method = "Static"
     tags = {
       "Team" = "Dev"
     }
}
