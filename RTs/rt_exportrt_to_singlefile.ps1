Write-Host '################################################' -fore yellow
Write-Host 'EXPORT RT for Subscription into single file' -fore yellow
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
$azSubName = (Get-AzContext).Subscription.Name

$exportPath = Read-Host -Prompt 'Export Path'

# Below will now loop trough all the NSgs in the Subscription you chose and export them to CSV
# Each RT will be exported to the same csv file, where the name will be Subscription-routes.csv
$rtables = Get-AzRouteTable

foreach ( $rt in $rtables )
{

    Get-AzRouteConfig -RouteTable $rt | `
            Select-Object @{label = 'RT name'; expression = { $rt.Name } }, `
        @{label = 'RT Location'; expression = { $rt.Location } }, `
        @{label = 'route name'; expression = { $_.Name } }, `
        @{label = 'Address Prefix'; expression = { $_.AddressPrefix } }, `
        @{label = 'Next Hop Type'; expression = { $_.NextHopType } }, `
        @{label = 'Next Hop Ip'; expression = { $_.NextHopIpAddress } } | `

        Export-Csv -Path "$exportPath\$azSubName-routes.csv" -NoTypeInformation -Append -force


}

Write-Host '###############' -fore yellow
Write-Host 'Sript Completed' -fore yellow
Write-Host '###############' -fore yellow
