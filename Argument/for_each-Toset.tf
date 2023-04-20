/*
observation: 
1] 3 resource groups will be generated in plan 
2] Review Resource Name ResourceType.ResourceLocalName[each.key] in terraform plan 
3] Review Resource Group Names 

myrg-eastus
myrg-eastus2
myrg-westus
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
resource "azurerm_resource_group" "myrg" {
    for_each = toset(["eastus","eastus2","westus"])
    name = "myrg-${each.value}"
    location = each.key
  
}
