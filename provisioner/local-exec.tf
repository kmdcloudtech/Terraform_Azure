  # local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  provisioner "local-exec" {
    command = "echo ${azurerm_linux_virtual_machine.mylinuxvm-1.public_ip_address} >> creation-time.txt"
    working_dir = "local-exec-output-files/"
    #on_failure = continue
  }

