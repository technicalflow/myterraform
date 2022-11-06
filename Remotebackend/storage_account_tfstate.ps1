$RG = "dev5"
$storageAccountName = "devtfstate$(1..100 | Get-Random -Count 5 | Select -First 1)"
$containerName = "tstate"

# Create storage account
az storage account create -g $RG -n $storageAccountName --sku Standard_LRS --encryption-services blob

#Retrieve primary connection key
$storageAccountKey = $(az storage account keys list -g $RG --account-name $storageAccountName --query [0].value -o tsv)

# Create container
az storage container create -n $containerName --account-name $storageAccountName --account-key $storageAccountKey
