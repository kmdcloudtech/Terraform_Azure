variable "rgname" {
    type = string 
    default = "devRG"
  
}

variable "vnetname" {
    type = string 
    default = "devVnet"
  
}
###################################### step 1 ############
####################################### step 2 ###########
# business unit name
variable "bu" {
    description = "Business unit name"
    type = string 
    default = "hr"

}
# Environtment Name
variable "env" {
    description = "Environment Name"
    type = string 
    default = "dev"
  
}
# Resource Group Name 
variable "rg_name" {
  description = "Resource Group Name"
  type = string 
  default = "myRg"
}
# Resource Group Location 
variable "rg_loc" {
    description = "Resource Group Location"
    type = string 
    default = "East US"
  
}
# Virtula Network name 
variable "vnet_name" {
    description = "Virtual network name"
    type = string 
    default = "myvnet"
  
}


