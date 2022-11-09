param(
    [string]
    $test
    )
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

    foreach ($nsg in $nsgs) {

# save ResourceGroupName for each nsg
      $rgName = $nsg.ResourceGroupName
      $nsgName = $nsg.Name
      $nsgRegion = $nsg.Location
      $nsgRules = Get-AzNetworkSecurityRuleConfig -NetworkSecurityGroup $nsg

      if ($nsgName.Contains("uks") -and $nsgRegion -eq $azPriRegion -and -not($nsgName.Contains("hub")))
      {
        $modify = "true"
      }
      else{
        $modify = "false"
      }

      switch($modify)
          {
            "true"
            {
              $test = $nsgRules.SourceAddressPrefix
              Write-Host $test.Contains("10.10")
              $newtest = $test.Replace("10.10", "10.11")
              $nsgRules.SourceAddressPrefix = $test
              Write-Host $newtest
              Write-Host $nsgRules.SourceAddressPrefix

              # for ($i = 0; $i -le $nsgRules.SourceAddressPrefix.Count; $i++) {
              #
              # Write-Host $nsgRules.SourceAddressPrefix[$i]
              # Write-Host $nsgRules.SourceAddressPrefix[$i].Contains("10.10")
              # }
              # Write-Host $nsgRules.SourceAddressPrefix.Count
              # Write-Host $nsgName to be modified
              # Write-Host Current RG name $rgName
              # $drRgName = $rgName.replace("uks", "ukw")
              # Write-Host Dr RG name $drRgName
              # Write-Host Current NSG name $nsgName
              # $drNsgName = $nsgName.replace("uks", "ukw")
              # Write-Host Dr NSG name $drNsgName

              break
            }
            "false"
            {
              Write-Host nsg to not modify $nsgname
              break
            }


          }

      }
 }
