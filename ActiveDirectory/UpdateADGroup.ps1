﻿#Active Directory Group Name To Be Edited
#Load Active Directory Module
if(@(get-module | where-object {$_.Name -eq "ActiveDirectory"} ).count -eq 0) {import-module ActiveDirectory}

###Functions
function Get-FSMORoles
{
Param (
  $Domain
  )
  
  $DomainDN = $Domain.defaultNamingContext
  
  $FSMO = @{}
#  PDC Emulator
  $PDC  = [adsi]("LDAP://"+ $DomainDN)
  $FSMO  = $FSMO + @{"PDC" = $PDC.fsmoroleowner}
  return $FSMO
}
$Role = (Get-FSMORoles ([adsi]("LDAP://RootDSE")))

$PDC = $Role.PDC.ToString().split(",")[1]
$PDC = $PDC.ToString().split("=")[1]

#Active Directory Group Name
$group="Test"

#Search Active Directory for Users with Department X (Searches "PDC")
$Users = Get-ADUser -Server $PDC -Filter {(department -eq "test") -and (objectclass -eq "user")}

#Check to make sure Active Directory group exists
$checkGroup=Get-ADGroup -Server $PDC -Filter {(name -eq $group)}

if($checkGroup -eq $null)
	{echo "Group Doesn't Exist"; exit}

#Get Members of the $group including child groups
$groupmembers = Get-ADGroupMember  "$group" -recursive -Server $PDC
#Prep new array
$gmembers = @()
#Muck with groupmembers arrary data
Foreach ($member in $groupmembers) {
	$gmembers += $member.SamAccountName
	}
	
#Check to see if User is already a member of the group
Foreach ($User in $Users) {
	If ($gmembers -notcontains $User.SamAccountName){Add-ADGroupMember -Server $PDC $group $User.SamAccountName }
	}