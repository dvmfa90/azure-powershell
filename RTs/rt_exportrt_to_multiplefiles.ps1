#
# NOTE: You will noticed that besides getting the normal fields from the route table exported to the CSV you will have an extra TAB named Action. This extra TAB is to combine together with rt_manipulate.ps1 script where using this Action filed, you can type Add or Delete in the action Column in case you want to either add or delete Routes.
#
Write-Host '################################################' -fore yellow
Write-Host 'EXPORT RTs for Subscription into multiple files' -fore yellow
Write-Host '################################################' -fore yellow

Write-Host 'Connect to Azure' -fore yellow


#Connect to Azure
Connect-AzAccount

# List subscriptions you have acces to
Write-Host 'List Subscriptions' -fore yellow

Get-AzSubscription | Format-List -Property Name,Id

# Type or paste the Subscription ID you want to export the RTs
$azSubs = Read-Host -Prompt 'Subscription ID'

Set-AzContext -Subscription $azSubs

# Type the path where you want to output the exported CSV files. ex below:
#'C:\Users\JohnDoe\RT\'
$exportPath = Read-Host -Prompt 'Export Path'

# Below will now loop trough all the NSgs in the Subscription you chose and export them to CSV
# Each RT will be exported to a dedicated CSV where the name will be the NSG Name.csv
$rtables = Get-AzRouteTable

foreach ( $rt in $rtables )
{

    $rtname = $rt.Name
    Get-AzRouteConfig -RouteTable $rt | `
            Select-Object @{label = 'RT name'; expression = { $rt.Name } }, `
        @{label = 'RT Location'; expression = { $rt.Location } }, `
        @{label = 'route name'; expression = { $_.Name } }, `
        @{label = 'Address Prefix'; expression = { $_.AddressPrefix } }, `
        @{label = 'Next Hop Type'; expression = { $_.NextHopType } }, `
        @{label = 'Next Hop Ip'; expression = { $_.NextHopIpAddress } }, `
        @{label = 'Action'; expression = "Action"} | `
            Export-Csv -Path "$exportPath\$rtname.csv" -NoTypeInformation -Append -force


}

Write-Host '###############' -fore yellow
Write-Host 'Sript Completed' -fore yellow
Write-Host '###############' -fore yellow
