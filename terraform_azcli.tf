#Input :
variable "TenantId" { type = string }
variable "SubscriptionId" { type = string }
variable "AzureRMClientId" { type = string }
variable "AzureRMClientSecret" { type = string }
variable "rg_name" { type = string }
variable "location" { type = string }
variable "sa_name" { type = string }
variable "container_name" { type = string }


# https://www.terraform.io/docs/provisioners/local-exec.html
resource "null_resource" "AzLoginAndSetSubscription" {
  provisioner "local-exec" {
    command = <<EOT
      $tenantId = "${var.TenantId}" 
      $subscriptionId = "${var.SubscriptionId}" 
      $azureRMClientId = "${var.AzureRMClientId}" 
      $azureRMClientSecret = "${var.AzureRMClientSecret}" 
      $RESOURCE_GROUP_NAME = "${var.rg_name}"
      $LOCATION = "${var.location}"
      $STORAGE_ACCOUNT_NAME = "${var.sa_name}"
      $CONTAINER_NAME = "${var.container_name}"

      Write-Host "Az Login with Client Id = $azureRMClientId "
      az login --service-principal -u $azureRMClientId -p $azureRMClientSecret  --tenant $tenantId
      az account set --subscription $subscriptionId
      az group create --name $RESOURCE_GROUP_NAME --location $LOCATION
      az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
      az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
    EOT

    interpreter = ["PowerShell", "-Command"]
  }
}
