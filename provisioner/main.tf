/*
for attachment of ssh keys 
step-1: first create ssh-keys folder in same folder 
cd ssh-keys 
step-2: create public key and private key with ssh-keygen command 
ssh-keygen : give actual path of folder with terraform-azure 
it will create two keys in .ssh folder 
terraform-azure terraform-azure.pub 
change name of pvt key 
  mv terraform-azure terraform.pem 
  chmod 400 terraform-azure.pem 
  now create a simple index.html file in same folder (provision folder) 
 
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
# virtual network 
resource "azurerm_virtual_network" "myvnet" {
    name = "myvnet-1"
    address_space = ["10.0.0.0/16"]
    location = azurerm_resource_group.demoRG.location 
    resource_group_name = azurerm_resource_group.demoRG.name 
  
}
# subnet
resource "azurerm_subnet" "mysubent" {
    name = "mysubnet-1"
    resource_group_name = azurerm_resource_group.demoRG.name 
    virtual_network_name = azurerm_virtual_network.myvnet.name
    address_prefixes = ["10.0.0.0/24"]

}
# NSG Code 
resource "azurerm_network_security_group" "example" {
  name = "example-nsg"
  resource_group_name = azurerm_resource_group.demoRG.name 
  location = azurerm_resource_group.demoRG.location
  
  security_rule = {
    
    name      = "ssh"
    priority  = 300
    direction = "Inbound"
    access    = "Allow"
    protocol  = "TCP"
    source_address_prefix = "*"
    ## source_address_prefixes = [ "value" ]
  
    source_port_range      = "*"
    destination_port_range = "22"
     # destination_port_ranges = [ "value" ]
    destination_address_prefix = "*"
     
}
}

# NSG Association 
resource "azurerm_subnet_network_security_group_association" "example-asso" {
  subnet_id = azurerm_subnet.mysubent.id 
  network_security_group_id = azurerm_network_security_group.example.id
  
}

# public ip
resource "azurerm_public_ip" "mypublicip" {
    name = "mypublicip-1"
    resource_group_name = azurerm_resource_group.demoRG.name
    location = azurerm_resource_group.demoRG.location 
    allocation_method = "Static"
    tags = {
      "team" = "dev"
    }
  
}
# NIC 
resource "azurerm_network_interface" "myvmnic" {
    name = "vmnic"
    location = azurerm_resource_group.demoRG.location
    resource_group_name = azurerm_resource_group.demoRG.name
    ip_configuration {
      name = "internal"
      subnet_id = azurerm_subnet.mysubent.id 
      private_ip_address_allocation = "Dynamic"
      public_ip_address_id = azurerm_public_ip.mypublicip.id
    }
}
# vm 
resource "azurerm_linux_virtual_machine" "mylinuxvm-1" {
  name = "mylinxvm-1"
  computer_name = "devlinux"
  resource_group_name = azurerm_resource_group.demoRG.name
  location = "Central India"
  size = "Standard_F2"
  admin_username = "cloud"
  # admin_password = "Azure@123"
  # disable_password_authentication =  false
  network_interface_ids = [azurerm_network_interface.myvmnic.id,]
  # file function 
  admin_ssh_key {
    username = "cloud"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
 
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "OpenLogic"
    offer = "CentOS"
    sku = "7.5"
    version = "latest"
  }
# provisioner Block
  connection {
    type = "ssh"
    user = self.admin_username
    private_key = file("${path.module}/ssh-keys/terraform-azure.pem")
    host = self.public_ip_address
  }

  provisioner "file" {
    source = "index.html"
    destination = "/tmp/index.html"
    
  }
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir /root/terraform",
      "sudo yum install httpd -y",
      "sudo systemctl start httpd",
      "sudo systmeclt enable httpd",
      "sudo cp /tmp/index.html /var/www/html"
    ]
    
  }
}
