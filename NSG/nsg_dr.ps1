Write-Host '##########' -fore yellow
Write-Host 'NSG' -fore yellow
Write-Host '##########' -fore yellow

Write-Host 'Connect to Azure' -fore yellow

# Connect to Azure
Connect-AzAccount

$azSubs = "Visual Studio Enterprise Subscription – MPN"
$azPriRegion = "uksouth"
$azDrRegion = "ukwest"
$azPriAddressSpace = "10.10.0.0/16"
$azDrAddressSpace = "10.11.0.0/16"



Set-AzContext -Subscription $azSubs

# Save nsgs that exist in the Subscription
foreach ($nsgs in $azSubs) {
  $nsgs = Get-AzNetworkSecurityGroup

# loop through all nsgs
    foreach ($nsg in $nsgs) {

# save ResourceGroupName for each nsg
      $rgname = $nsg.ResourceGroupName
      $nsgname = $nsg.Name
      $nsgRegion = $nsg.Location

      if ($nsgRegion -eq $azPriRegion -and $nsgname.contains("uks")){
    $nsgRules = Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg

    Write-Host $nsgname
    # Write-Host $nsgRules.SourceAddressPrefix
    $addressprefix = $nsgRules.SourceAddressPrefix
    Write-Host $addressprefix

    if ($addressprefix.Contains("10.10"))
    {
      Write-Host "Cheguei aqui"
      $nsgTest = $addressprefix.replace("10.10", "10.11")
      Write-Host $nsgTest
    }





# checks if nsg RG name contains primary region reference and if it does replaces that bit to DR region
# Check if it works with Capital letters ex. UKS
# might not need this in our work since rgs are always created following this
      if ($rgname.contains("$azPriRegion"))
      {
        $drrgname = $rgname.replace("$azPriRegion", "$azDrRegion")

      }

# checks if nsg name contains primary region reference and if it does replaces that bit to DR region
# Check if it works with Capital letters ex. UKS
      if ($nsgname.contains("uks"))
      {
        # Write-Host $nsgname
        # below to be uncommented
        # $drrgname = $rgname.replace("$azPriRegion", "$azDrRegion")

        $drnsgname = $nsgname.replace("uks", "ukw")
        # Write-Host $drnsgname
        $destNSGLocation = "ukwest"


        # New-AzNetworkSecurityGroup -ResourceGroupName $drrgname -name $drnsgname -Location $destNSGLocation
      }

      }





    }






  # New-AzNetworkSecurityGroup -ResourceGroupName $dstRG -name $destNSG -Location $destNSGLocation -SecurityRules $NSG.SecurityRules
}

