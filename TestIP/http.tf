provider "http" {

}

provider "tls" {

}

provider "null" {

}

provider "local" {

}


resource "null_resource" "nr" {
  provisioner "local-exec" {
    command = "curl icanhazip.com > terraform1.tfvars"
    # interpreter = ["pwsh", "-Command"]
  }

  # provisioner "local-exec" {
  #   command = "export SSH_IP=$(curl -s icanhazip.com)"
  # }
}

data "local_file" "file" {
  filename = "terraform1.tfvars"

  depends_on = [
    null_resource.nr
  ]
}

output "file" {
  value = data.local_file.file.content
}

data "http" "ipcheck" {
  url = azurerm_public_ip.pip[0].ip_address
  depends_on = [
    azurerm_linux_virtual_machine.vm
  ]
}

# resource "null_resource" "httpcheck" {
#     provisioner "local-exec" {
#       command = contains([200, 204], data.http.ipcheck.status_code)

#     }
# }

resource "tls_private_key" "privatekey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "name" {
  content  = tls_private_key.privatekey.private_key_openssh
  filename = "sshkey"
}

# output "privatekeyoutput" {
#   sensitive = true
#   value = tls_private_key.privatekey.private_key_openssh
# }

# output "publickeyoutput" {
#   sensitive = true
#   value = tls_private_key.privatekey.public_key_openssh
# }

output "ipcheck_http" {
  value = data.http.ipcheck.status_code
}