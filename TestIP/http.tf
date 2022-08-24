provider "http" {

}

provider "tls" {

}

provider "null" {

}

provider "local" {

}

data "http" "ipcheck" {
  url = "http://testip.fun"
  depends_on = [
    azurerm_linux_virtual_machine.vm
  ]
}

# resource "null_resource" "httpcheck" {
#     provisioner "local-exec" {
#       command = contains([201, 204], data.http.ipcheck.status_code)

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