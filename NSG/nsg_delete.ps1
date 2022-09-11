Write-Host '##########' -fore yellow
Write-Host 'Delete NSG' -fore yellow
Write-Host '##########' -fore yellow

Write-Host 'Connect to Azure' -fore yellow

# Connect to Azure
Connect-AzAccount

# List Azure Subscriptions that your user has access to.
Write-Host 'List Subscriptions' -fore yellow

Get-AzSubscription | Format-List -Property Name,Id

# Below will allow you to paste the Subscription ID associated with the NSG you want to delete
$azSubs = Read-Host -Prompt 'Subscription ID of NSG to delete'

Set-AzContext -Subscription $azSubs

# Below will list all the NSGs associated with the subscription you chose
Get-AzNetworkSecurityGroup | Format-List -Property Name,ResourceGroupName,Location

#Below code will ask you to paste or type the name of the NSG you want to delete and the Resource Group where the NSG is.
$sourceNSG= Read-Host -Prompt 'NSG you want to delete'

$srcRG= Read-Host -Prompt 'Resource Group of NSG you want to delete'
# This last bit will now delete the NSG you chose.
Remove-AzNetworkSecurityGroup -Name $sourceNSG -ResourceGroupName $srcRG

Write-Host "NSG (" $sourceNSG ") deleted"
