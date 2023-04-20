/*
Observation: 
1] 3 Resource Groups will generated in Plan
2] Review Resource Names ResourceType.ResourceLocalName[each.key] in terrafor plan with names as given key in for_each segment
3] Review Resource Group Names Eastgroup,Centralgroup,westgroup 
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
            tags = {
              "Team" = "Dev"
              "Owner" = "Sudheer"
            }

}
resource "azurerm_resource_group" "myrg" {
    for_each = {
      eastgroup             = "eastus"
      centralgroup          = "Centralindia"
      westgroup             = "westus"
    }
  name = "${each.key}-rg"
  location = each.value
}
