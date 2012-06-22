<#
.SYNOPSIS
Gets and counts members of a group caught as a unique ACL containing ASIAPAC in its name
.PARAMETER
The UNC path of a folder
.DESCRIPTION
Determines unique ACL groups that contain ASIAPAC in their name from a user provided UNC path
.EXAMPLE
get-UNC-folder-acls.ps1 -UNCPath \\cscsrvmel7\d$\Groups -target_folder VWA
#>
[CmdletBinding()]
param (
	[Parameter(Mandatory=$true)]
	[string]$UNCPath,
	[Parameter(Mandatory=$true)]
	[string]$target_folder
)

$previous_path=pwd
cd $UNCPath
$groups = get-acl $target_folder | select -expand access | where-object {$_.identityreference -like "*ASIAPAC*"} | select-Object -unique -expand identityreference 
foreach ($group in $groups) {
	get-qadgroupmember $group.ToString() | measure-object
}
cd $previous_path