Write-Host '##########' -fore yellow
Write-Host 'Delete RT' -fore yellow
Write-Host '##########' -fore yellow

# Connect to Azure
Write-Host 'Connect to Azure' -fore yellow

Connect-AzAccount

# List Azure Subscriptions that your user has access to.
Write-Host 'List Subscriptions' -fore yellow

Get-AzSubscription | Format-List -Property Name,Id

# Below will allow you to paste the Subscription ID associated with the RT you want to delete
$azSubs = Read-Host -Prompt 'Subscription ID of RT to delete'

Set-AzContext -Subscription $azSubs

# Below will list all the RTs associated with the subscription you chose
Get-AzRouteTable | Format-List -Property Name,ResourceGroupName,Location

$sourceRT= Read-Host -Prompt 'RT you want to delete'

$srcRG= Read-Host -Prompt 'Resource Group of RT you want to delete'

# This last bit will now delete the RT you chose.
Remove-AzRouteTable -Name $sourceRT -ResourceGroupName $srcRG

Write-Host "RT (" $sourceRT ") deleted"
