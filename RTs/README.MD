# Description

Powershell scripts that interact with Azure RTs. Most of the scripts provided are interactive scripts. All scripts have comments with brief explanations of what the code does.

The scripts: rt_exportrt_to_multiplefiles, rt_manipulate are handy together. The idea is to use rt_exportrt_to_multiplefiles to export RTs to .csv files(one per RT) so you get the current representation of the RT routes in the .CSV file. If you than want to manipulate it by either adding or remove routes, you can use the exported .CSV file, add either Add or Delete to the "Action" Column and then run the rt_manipulate.ps1 script that will import that CSV, look into the action filed and either add or delete routes.

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

        This script will allow you to chose a subscription, and will export all RTs in that subscription to a .csv file per RT.

    * rt_exportrtg_to_singlefile.ps1:

        Similar to the above one, but with one difference, rather than creating a .csv per RT it will put all the RT rules in a single .csv file.

    * rt_list:

        This script will ask you to chose a subscription and will list all the RTs in that subscription.

    * rt_manipulate:

        In this script you will "import" a .csv file, its important the the .csv file has the column "Action" on it. According to what you have in the column "Action" the script can remove and/or add routes according to what is front of each row in the action Column.
        Its very important to use the type Add or Delete these are case sensitive.

# Ideas on following scripts:


    * Create a script similar to rt_manipulate where you can chose if you want to change one or multiple RTs. If you chose multiple, you could import a csv, add "Add" or "Delete" in front of the routes to either add or delete routes on multiple RTs
    * Add a to the rt_manipulate an export of the route table to .csv with after changes status.
