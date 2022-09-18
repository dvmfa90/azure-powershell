Write-Host '##########' -fore yellow
Write-Host 'Clone NSG' -fore yellow
Write-Host '##########' -fore yellow

# Connect to Azure
Write-Host 'Connect to Azure' -fore yellow

Connect-AzAccount

# List Azure Subscriptions that your user has access to.

Write-Host 'List Subscriptions' -fore yellow

Get-AzSubscription | Format-List -Property Name,Id

# Below will allow you to paste the Subscription ID associated with the NSG you want to clone and set that Subscription as the context
$azSubs = Read-Host -Prompt 'Subscription ID of NSG to clone'

Set-AzContext -Subscription $azSubs
# Below will list all the NSGs associated with the subscription you chose
Get-AzNetworkSecurityGroup | Format-List -Property Name,ResourceGroupName,Location

#Below lines will allow you to paste the NSG you want to clone and the Resource Group that NSG belongs to (In Azure you can have NSGs with the same name as long as they are in an different Resource Group)
$sourceNSG= Read-Host -Prompt 'NSG you want to clone'

$srcRG= Read-Host -Prompt 'Resource Group of NSG you want to clone'

# Below will save into the variable $NSG the NSG you selected to clone.
$NSG=Get-AzNetworkSecurityGroup -ResourceGroupName $srcRG -name $sourceNSG

# Below will now show you again a list of Subscriptions, ask you to chose one for the cloned NSG, ask you the name of the cloned NSG and also its Resource Group and location
Get-AzSubscription | Format-List -Property Name,Id

$dstSubs = Read-Host -Prompt 'Subscription ID for cloned NSG'

Set-AzContext -Subscription $dstSubs

$destNSG= Read-Host -Prompt 'Name of cloned NSG'

Get-AzResourceGroup | Format-List -Property ResourceGroupName

$dstRG= Read-Host -Prompt 'Resource Group of where you want cloned NSG'

Get-AzLocation  | Format-List -Property Location

$destNSGLocation = Read-Host -Prompt 'Choose Location for cloned NSG'

# This final bit will now create the cloned NSG based on the one you select in the beggining.

New-AzNetworkSecurityGroup -ResourceGroupName $dstRG -name $destNSG -Location $destNSGLocation -SecurityRules $NSG.SecurityRules

Write-Host '###############' -fore yellow
Write-Host 'Sript Completed' -fore yellow
Write-Host '###############' -fore yellow
