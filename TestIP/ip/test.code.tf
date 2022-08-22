# variable "IP2" {
#   type = string
# }

# provisioner "local-exec" {
#   command = "/bin/bash deploy.sh"
# }

resource "null_resource" "example2" {
  provisioner "local-exec" {
    command = "echo IP2 = >> terraform1.tfvars"
  }
  provisioner "local-exec" {
    command = "curl icanhazip.com >> terraform1.tfvars"
    # interpreter = ["pwsh", "-Command"]
  }
  # provisioner "local-exec" {
  #   command = "echo 'IP2 ='; cat terraform1.tfvars > terraform1.tfvars"
  # }
  # provisioner "local-exec" {
  #   command = "sed -i '1i IP2=' terraform.tfvars"
  # }
}

resource "null_resource" "example3" {
  # provisioner "local-exec" {
  #   command = "echo variable '"ip"' { >> test.tf"
  # }
  # provisioner "local-exec" {
  #   command = "echo default = >> test.tf"
  # }
  # provisioner "local-exec" {
  #   command = "curl -s testip.fun >> test.tf"
  # }
  # provisioner "local-exec" {
  #   command = "echo } >> test.tf"
  # }
}


# data "external" "example" {
#   program = ["python", "${path.module}/example-data-source.py"]

#   query = {
#     # arbitrary map from strings to strings, passed
#     # to the external program as the data query.
#     id = "abc123"
#   }
# }


# output "newip2" {
#   value = var.IP2
# }