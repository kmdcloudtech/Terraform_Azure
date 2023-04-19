#  Create a stroage account with blocb storage with public access and versioning Enable
# create a container inside the storage account name as tfstate 
# Now attach details of storage account with backend block 

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

# Backend Block 
terraform {
  backend "azurerm" {
    resource_group_name = "demoRG"
    storage_account_name = "xxxxx"
    container_name = "tfstate"
    key = "prod.terraform.tfstate"
  }
}
resource "azurerm_resource_group" "demoRG" {   # Reference Name
            name = "demoRG"
            location = "Central India"
            tags = {
              "Team" = "Dev"
              "Owner" = "Sudheer"
            }

}
