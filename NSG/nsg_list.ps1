Write-Host '##########' -fore yellow
Write-Host 'List NSGs' -fore yellow
Write-Host '##########' -fore yellow

# Conect to Azure
Write-Host 'Connect to Azure' -fore yellow

Connect-AzAccount
# List Subscriptions you have access to and allow you to chose the one where you want to List NSGs
Write-Host 'List Subscriptions' -fore yellow

Get-AzSubscription | Format-List -Property Name,Id

$azSubs = Read-Host -Prompt 'Subscription ID '

Set-AzContext -Subscription $azSubs

# Below code will now list all the NSGs associated with the Susbcription you chose.
Get-AzNetworkSecurityGroup | Format-List -Property Name,ResourceGroupName,Location


