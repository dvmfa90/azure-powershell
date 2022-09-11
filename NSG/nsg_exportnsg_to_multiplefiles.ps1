Write-Host '################################################' -fore yellow
Write-Host 'EXPORT NSGs for Subscription into multiple files' -fore yellow
Write-Host '################################################' -fore yellow

#Connect to Azure
Write-Host 'Connect to Azure' -fore yellow

Connect-AzAccount

# List subscriptions you have acces to
Write-Host 'List Subscriptions' -fore yellow

Get-AzSubscription | Format-List -Property Name,Id

# Type or paste the Subscription ID you want to export the NSGs
$azSubs = Read-Host -Prompt 'Subscription ID'


# Type the path where you want to output the exported CSV files. ex below:
#'C:\Users\JohnDoe\NSG\'

$exportPath = Read-Host -Prompt 'Export Path'

Set-AzContext -Subscription $azSubs

# Below will now loop trough all the NSgs in the Subscription you chose and export them to CSV
# Each NSG will be exported to a dedicated CSV where the name will be the NSG Name.csv
$nsgs = Get-AzNetworkSecurityGroup

foreach ( $azNsg in $nsgs )
{
    $nsgname= $azNsg.Name
    # Export custom rules
    Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $azNsg | `
            Select-Object @{label = 'NSG'; expression = { $azNsg.Name } }, `
        @{label = 'RG'; expression = { $azNsg.ResourceGroupName } }, `
        @{label = 'Location'; expression = { $azNsg.Location } }, `
        @{label = 'Rule Name'; expression = { $_.Name } }, `
        @{label = 'Source'; expression = {[string]::join(';', ($_.SourceAddressPrefix))}}, `
        @{label = 'Source ASG'; expression = { $_.SourceApplicationSecurityGroups.id.Split('/')[-1] } },
        @{label = 'Src Port Range'; expression = { $_.SourcePortRange } }, `
        @{label = 'Destination'; expression = {[string]::join(';', ($_.DestinationAddressPrefix)) } }, `
        @{label = 'Destination ASG'; expression = { $_.DestinationApplicationSecurityGroups.id.Split('/')[-1] } }, `
        @{label = 'Dst Port Range'; expression = {[string]::join(';', ($_.DestinationPortRange))}}, `
        @{label = 'Protocol'; expression = { $_.Protocol } }, `
        @{label = 'Access'; expression = { $_.Access } }, `
        @{label = 'Priority'; expression = { $_.Priority } }, `
        @{label = 'Direction'; expression = { $_.Direction } }, `
        @{label = 'Rule Description'; expression = { $_.Description } } | `
            Export-Csv -Path "$exportPath\$nsgname.csv" -NoTypeInformation -Append -force

    Write-Host "(" $nsgname ") Exported"


}

Write-Host '###############' -fore yellow
Write-Host 'Sript Completed' -fore yellow
Write-Host '###############' -fore yellow
