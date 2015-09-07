#Load Quest Active Directory Managment CMDLETs
if(Get-PSSnapin | Where-Object {$_.Name -eq "Quest.ActiveRoles.ADManageMent"}){Echo "CMDLETs Already Loaded"}
else {Add-PSSnapin Quest.ActiveRoles.ADManagement}

# Creates Arraylist object
$adduserou = New-Object system.collections.arraylist 

#Active Directory Group Name To Be Edited
$groupname="eobu-dum-sp-mkiallread"

#Active Directory path for the group that you will be editing
$groupou="ou=Groups,ou=DUM,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com"

#Active Directory path(s) for the OU that you want to search for users + add to array
$adduserou.add("ou=Remote,ou=Users,ou=DUM,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com") | out-null
$adduserou.add("ou=Local,ou=Users,ou=DUM,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com")| out-null
$adduserou.add("ou=Remote,ou=Users,ou=STF,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com")| out-null
$adduserou.add("ou=Local,ou=Users,ou=STF,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com")| out-null
$adduserou.add("ou=Remote,ou=Users,ou=ORL,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com")| out-null
$adduserou.add("ou=Local,ou=Users,ou=ORL,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com")| out-null

#Check to make sure Active Directory group exists
$checkGroup=Get-QADGroup -SearchRoot "$groupou" -Name "$groupname"

if($checkGroup -eq $null)
      {echo "Group Doesn't Exist"; exit}

#Remove All Users From The Current Group
$target=Get-QADGroupMember prod\$groupname -Indirect
      foreach ($user in $target) {Remove-QADGroupMember "cn=$groupname,$groupou" -member $user.dn}

# Scan OU and Add Members to Group
foreach($ou in $adduserou){
      $target = get-QADUser -searchroot $ou -searchScope 'OneLevel'
      foreach ($user in $target) {add-QADGroupMember -identity "cn=$groupname,$groupou" -member $user.dn}
}
