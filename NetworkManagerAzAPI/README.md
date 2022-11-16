### Network Manager <br>

The code uses AzAPI terraform provider which feels the gap between Azure ARM and terraform AzureRM provider list of functions <br>
For now we are able to create Network Manager Instance together with Static Network Groups.<br><br>

The code in the repository creates 3 VNETs (two in France Central and one in West Europe) and places them in one resource group. <br>
One Network Manager is created in the same resource group and placed in France Central. <br>
From the configuration stand point Connectivity Configuration and Security Admin Rules are fully supported <br>
Security User Groups despite being available with AzAPI provider are not yet implemented on the platform side. <br>
At the moment there are no API calls available for deploying the configuration so powershell script is used with null_resource <br>

Cross tenant connections and connecting two Network Managers are ready in the code but not tested. <br><br>
More about Network Manager<br>
https://learn.microsoft.com/en-us/azure/virtual-network-manager/overview <br> 
https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-use-cases <br>
https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-security-admins <br><br>

Readme for AzAPI<br>
For more information on Terraform AzAPI Azure Network Manager usage go to: <br>
https://learn.microsoft.com/en-us/rest/api/networkmanager/ <br>
https://learn.microsoft.com/en-us/azure/templates/microsoft.network/networkmanagers/connectivityconfigurations?pivots=deployment-language-terraform <br>