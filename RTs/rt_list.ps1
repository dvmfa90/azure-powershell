Write-Host '##########' -fore yellow
Write-Host 'List Route Tables' -fore yellow
Write-Host '##########' -fore yellow

# Connect to Azure
Write-Host 'Connect to Azure' -fore yellow

Connect-AzAccount

# List Subscriptions you have access to and allow you to chose the one where you want to List RTs
Write-Host 'List Subscriptions' -fore yellow

Get-AzSubscription | Format-List -Property Name,Id

$azSubs = Read-Host -Prompt 'Subscription ID '

Set-AzContext -Subscription $azSubs

# Below code will now list all the RTs associated with the Susbcription you chose.
Get-AzRouteTable | Format-List -Property Name,ResourceGroupName,Location


