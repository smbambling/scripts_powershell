##Load Quest Active Directory Managment CMDLETs
if(Get-PSSnapin | Where-Object {$_.Name -eq "Quest.ActiveRoles.ADManageMent"}){Echo "CMDLETs Already Loaded"}
else {Add-PSSnapin Quest.ActiveRoles.ADManagement}

# Creates Arraylist object
$addgroup = New-Object system.collections.arraylist 
$addgroupim = New-Object system.collections.arraylist

#Active Directory Group Name To Be Edited
#Make sure that both array colums  match for the groups that you want to update
$addgroupim.add("eobu-dum-im-fms") | out-null
$addgroupim.add("eobu-dum-im-aclcl") | out-null
$addgroupim.add("eobu-dum-im-eps") | out-null
$addgroupim.add("eobu-dum-im-it") | out-null
$addgroupim.add("eobu-dum-im-mcfit") | out-null
$addgroupim.add("eobu-dum-im-acqmos") | out-null
$addgroupim.add("eobu-dum-im-set") | out-null
$addgroupim.add("eobu-dum-im-opforsys") | out-null
$addgroupim.add("eobu-dum-im-iuid") | out-null
$addgroupim.add("eobu-dum-im-cpac") | out-null
$addgroupim.add("eobu-dum-im-tmcr") | out-null

#Active Directory path(s) for the OU that you want to search for users + add to array
#Make sure that both array colums  match for the groups that you want to update
$addgroup.add("dum-fms") | out-null
$addgroup.add("dum-aclcl") | out-null
$addgroup.add("dum-eps") | out-null
$addgroup.add("dum-it") | out-null
$addgroup.add("dum-mcfit") | out-null
$addgroup.add("dum-acqmos") | out-null
$addgroup.add("dum-set") | out-null
$addgroup.add("dum-opforsys") | out-null
$addgroup.add("dum-iuid") | out-null
$addgroup.add("dum-cpac") | out-null
$addgroup.add("dum-tmcr") | out-null

#Active Directory path for the group that you will be editing
$groupou="ou=Groups,ou=DUM,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com"

#Check to make sure Active Directory group exists
foreach($groupname in $addgroupim){
	$checkGroup=Get-QADGroup -SearchRoot "$groupou" -Name "$groupname"
	if($checkGroup -eq $null){echo "Group $groupname Doesn't Exist"; exit}
}

#Check to make sure Active Directory group exists
foreach($groupname in $addgroup){
	$checkGroup=Get-QADGroup -SearchRoot "$groupou" -Name "$groupname"
	if($checkGroup -eq $null){echo "Group $groupname Doesn't Exist"; exit}
}

$checkGroup=Get-QADGroup -SearchRoot "$groupou" -Name "$groupname"
if($checkGroup -eq $null){echo "Group Doesn't Exist"; exit}

#Remove All Users From The Current Group
foreach($groupname in $addgroupim){
$target=Get-QADGroupMember prod\$groupname -Indirect   
      foreach ($user in $target) {Remove-QADGroupMember "cn=$groupname,$groupou" -member $user.dn}
}

#Adds members from 1 group to the other group
$i=0
foreach($groupname in $addgroupim){
	$groupname1=$addgroup[$i]
	$target1=Get-QADGroupMember prod\$groupname1
	foreach ($user1 in $target1) {add-QADGroupMember "cn=$groupname,$groupou" -member $user1.dn }
	$i=$i+1
	Remove-QADGroupMember "cn=$groupname,$groupou" -member dum-it
}
write-host "Complete"