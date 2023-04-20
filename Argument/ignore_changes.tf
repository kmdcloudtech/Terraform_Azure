/*
create Resource Group without lifecycle argument and then edit the tags values manually on Portal,Then execute the file again
It will back the previous state and flush out the manual changes

Then use lifecycle argument here and change manually once again and run terraform apply once again ,
this time it will ignore the changes whatever we have done on portal
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
              ignore_changes = [
                tags,
              ]
            }
            tags = {
              "Team" = "dev"
            }
}
