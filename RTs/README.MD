# Description

Powershell scripts that interact with Azure RTs. Most of the scripts provided are interactive scripts. All scripts have comments with brief explanations of what the code does.

# Requirements:

    * Powershell
    * Powershell AZ-Modules

# How to run the scripts

    * Linux: Browse to the folder where the scripts are using your terminal and run: pwsh scriptname.ps1
    * Windows: Browse to the scripts folder, right click and open with Powershell or browse to the folder via powershell console and ./scriptname.ps1.

# Scripts:

    * rt_clone:

        This script will allow you to chose one RT and clone it to another subscription/resource group/region or even to clone it to the same place but of course you need to give it a new name.

    * rt_delete:

        This script will allow you to chose one RT and delete it.

    * rt_exportrt_to_multiplefiles.ps1:

        This script will allow you to chose a subscription, and will export all RTs in that subscription to a .csv file per NSG.

    * rt_exportrt_to_singlefile.ps1:

        Similar to the above one, but with one difference, rather than creating a .csv per RT it will put all the NSG rules in a single .csv file.

    * rt_list:

        This script will ask you to chose a subscription and will list all the RTs in that subscription.

