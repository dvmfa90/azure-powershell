Write-Host '################################################' -fore yellow
Write-Host 'EXPORT NSGs for Subscription into single file' -fore yellow
Write-Host '################################################' -fore yellow
# Connect to Azure
Write-Host 'Connect to Azure'

Connect-AzAccount
#
# Lis subscriptions you have acces to
Write-Host 'List Subscriptions'

Get-AzSubscription | Format-List -Property Name,Id


# Type or paste the Subscription ID you want to export the NSGs
$azSubs = Read-Host -Prompt 'Subscription ID'

# Type the path where you want to output the exported CSV file. ex below:
#'C:\Users\JohnDoe\NSG\'
$exportPath = Read-Host -Prompt 'Export Path'

Set-AzContext -Subscription $azSubs

$azSubName = (Get-AzContext).Subscription.Name



# Below will now loop trough all the NSgs in the Subscription you chose and export them to CSV
# Each NSG will be exported to a single CSV file with the Subscription-nsg-rules.csv as the name
$nsgs = Get-AzNetworkSecurityGroup

foreach ( $azNsg in $nsgs )
{
    # Export custom rules
    Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $azNsg | `
            Select-Object @{label = 'NSG Name'; expression = { $azNsg.Name } }, `
        @{label = 'NSG Location'; expression = { $azNsg.Location } }, `
        @{label = 'Rule Name'; expression = { $_.Name } }, `
        @{label = 'Source'; expression = { $_.SourceAddressPrefix } }, `
        @{label = 'Source Application Security Group'; expression = { $_.SourceApplicationSecurityGroups.id.Split('/')[-1] } },
        @{label = 'Source Port Range'; expression = { $_.SourcePortRange } }, Access, Priority, Direction, `
        @{label = 'Destination'; expression = { $_.DestinationAddressPrefix } }, `
        @{label = 'Destination Application Security Group'; expression = { $_.DestinationApplicationSecurityGroups.id.Split('/')[-1] } }, `
        @{label = 'Destination Port Range'; expression = { $_.DestinationPortRange } }, `
        @{label = 'Resource Group Name'; expression = { $azNsg.ResourceGroupName } } | `
            Export-Csv -Path "$exportPath\$azSubName-nsg-rules.csv" -NoTypeInformation -Append -force

    # Export default rules
    Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $azNsg -Defaultrules | `
            Select-Object @{label = 'NSG Name'; expression = { $azNsg.Name } }, `
        @{label = 'NSG Location'; expression = { $azNsg.Location } }, `
        @{label = 'Rule Name'; expression = { $_.Name } }, `
        @{label = 'Source'; expression = { $_.SourceAddressPrefix } }, `
        @{label = 'Source Port Range'; expression = { $_.SourcePortRange } }, Access, Priority, Direction, `
        @{label = 'Destination'; expression = { $_.DestinationAddressPrefix } }, `
        @{label = 'Destination Port Range'; expression = { $_.DestinationPortRange } }, `
        @{label = 'Resource Group Name'; expression = { $azNsg.ResourceGroupName } } | `
            Export-Csv -Path "$exportPath\$azSubName-nsg-rules.csv" -NoTypeInformation -Append -force

    # Or you can use the following option to export to a single CSV file and to a local folder on your machine
    # Export-Csv -Path ".\Azure-nsg-rules.csv" -NoTypeInformation -Append -force

}

Write-Host '###############'
Write-Host 'Sript Completed'
Write-Host '###############'
