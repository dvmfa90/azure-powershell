Write-Host '#########' -fore yellow
Write-Host 'Clone RT' -fore yellow
Write-Host '#########' -fore yellow

Write-Host 'Connect to Azure' -fore yellow


# Connect to Azure
Connect-AzAccount

# List Azure Subscriptions that your user has access to.
Write-Host 'List Subscriptions' -fore yellow

Get-AzSubscription | Format-List -Property Name,Id

# Below will allow you to paste the Subscription ID associated with the RT you want to clone and set that Subscription as the context
$azSubs = Read-Host -Prompt 'Subscription ID'

Set-AzContext -Subscription $azSubs

# Below will list all the RTs associated with the subscription you chose
Get-AzRouteTable | Format-List -Property Name,ResourceGroupName,Location

#Below lines will allow you to paste the RT you want to clone and the Resource Group that NSG belongs to (In Azure you can have NSGs with the same name as long as they are in an different Resource Group)

$sourceRT= Read-Host -Prompt 'Route table you want to clone'

$srcRG= Read-Host -Prompt 'Resource Group of Route table you want to clone'

# Below will save into the variable $RT the NSG you selected to clone.
$RT=Get-AzRouteTable -ResourceGroupName $srcRG -name $sourceRT

$RT=Get-AzRouteTable -name $sourceRT

# Below will now show you again a list of Subscriptions, ask you to chose one for the cloned RT, ask you the name of the cloned NSG and also its Resource Group and location
Get-AzSubscription | Format-List -Property Name,Id

$dstSubs = Read-Host -Prompt 'Subscription ID for cloned RT'

Set-AzContext -Subscription $dstSubs

$destRT= Read-Host -Prompt 'Name of cloned Route Table'

Get-AzResourceGroup | Format-List -Property ResourceGroupName

$dstRG= Read-Host -Prompt 'Resource Group of where you want cloned Route Table'

Get-AzLocation  | Format-List -Property Location

$destRtLocation = Read-Host -Prompt 'Choose Location for cloned route table'

# This final bit will now create the cloned RT based on the one you select in the beggining.
New-AzRouteTable -ResourceGroupName $dstRG -name $destRT -Location $destRtLocation -Route $RT.Routes

Write-Host '###############' -fore yellow
Write-Host 'Sript Completed' -fore yellow
Write-Host '###############' -fore yellow
