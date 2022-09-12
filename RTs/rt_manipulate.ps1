param(

    $resourceGroupName,

    [string]

    $rtname,

    [string]

    $addressprefix,

    [string]

    $action,
    [string]

    $nexthop,

    [string]

    $nexthopip

)
Write-Host '######################' -fore yellow
Write-Host 'Manipulate Route Table from CSV' -fore yellow
Write-Host '######################' -fore yellow

########## Login to Azure ###########

Write-Host 'Connect to Azure' -fore yellow

Connect-AzAccount

############ Interactive bit of code ###########


# Comment code from below line till next coment if you want to fill out the variables without interaction

Write-Host 'List Subscriptions' -fore yellow

Get-AzSubscription | Format-List -Property Name,Id

$azSubs = Read-Host -Prompt 'Subscription ID'

Write-Host($azSubs)

Set-AzContext -Subscription $azSubs

Get-AzRouteTable | Format-List -Property Name,ResourceGroupName,Location

$routetableName = Read-Host -Prompt 'Route table to Update'
$resourceGroupName = Read-Host -Prompt 'RG for the route table'
$csvFilePath = Read-Host -Prompt 'Route table csv full path'


# Comment code between this comment and previous comment

#Uncomment below 3 variables if you commented the interavtive code

# $routetableName = 'route table name'
# $resourceGroupName = 'resource group'
# $csvFilePath = 'csv full path'




Import-Csv $csvFilePath |`

    ForEach-Object {


        $routename = $_."route name"

        $addressprefix = $_."Address Prefix"

        $nexthop = $_."Next Hop Type"

        $nexthopip = $_."Next Hop Ip"

        $action = $_."Action"

        $rtRuleNameValue = Get-AzRouteTable -Name $routetableName -ResourceGroupName $resourceGroupName |  Get-AzRouteConfig -Name $routename -ErrorAction SilentlyContinue `

        switch ($action)
        {
            "Delete"
            {
                if($rtRuleNameValue.Name -match $routename)
                {
                    Get-AzRouteTable -Name $routetableName -ResourceGroupName $resourceGroupName | Remove-AzRouteConfig -Name $routename | Set-AzRouteTable

                } else
                {
                    Write-Host "The route you want to delete does not exist"
                }


            }
            "Add"
            {
                if($rtRuleNameValue.Name -match $routename)
                {

                    Write-Host "A route with this name (" $rtRuleNameValue.Name ") already exists"

                }

                else
                {
                    Get-AzRouteTable -Name $routetableName -ResourceGroupName $resourceGroupName |
                        Add-AzRouteConfig -Name $routename `
                            -AddressPrefix $addressprefix `
                            -NextHopType $nexthop `
                            -NextHopIpAddress $nexthopip |
                        Set-AzRouteTable

                    }


                }
            }
        }

