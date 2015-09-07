#Load Quest Active Directory Managment CMDLETs
if(Get-PSSnapin | Where-Object {$_.Name -eq "Quest.ActiveRoles.ADManageMent"}){Echo "CMDLETs Already Loaded"}
else {Add-PSSnapin Quest.ActiveRoles.ADManagement}

Clear-Host

#$var_dclist=get-qadcomputer -ComputerRole "DomainController"
$var_dclist="prod-dum-dc1","prod-vab-dc3","prod-arl-dc1","prod-hor-dc1","prod-etn-dc1","prod-vab-dc2","prod-css-dc1","prod-cha-dc1","prod-sta-dc1","prod-mar-dc1","prod-cam-dc1","prod-mis-dc1","prod-top-dc1","prod-jac-dc1","prod-pan-dc1","prod-lex-dc1","prod-orl-dc1","prod-stf-dc1"

Echo "Buiness Units"
Echo "_____________"

get-qadobject -SearchRoot "ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -SearchScope 'OneLevel' | Foreach-Object -process {$_.name}

$var_bu=Read-Host "`nSelect A Business Unit"

Clear-Host

Echo "Sites"
Echo "_____"

get-qadobject -SearchRoot "ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -SearchScope 'OneLevel' | Foreach-Object -process {$_.name}

$var_site=Read-Host "`nSelect A Site"

#Enter Group Name
$var_groupname=Read-Host "Please Enter your Group Name"

#Enter Group Type -- Acceptable values: 'Security'; 'Distribution'
Write-Host "[1] Security"
Write-Host "[2] Distribution"

$var_grouptype=Read-Host "Please Select A Group Type"
Switch ($var_grouptype) {
	1 {Write-Host "`n You've Selected Security"; $var_grouptype= "Security"}
	2 {Write-Host "`n You've Selected Distribution"; $var_grouptype= "Distribution"}
	}

If ( $var_grouptype -eq Distribution) { 

	#Enter Group Scope -- Acceptable values: 'Global'; 'Universal'; 'DomainLocal'.
	Write-Host "[1] Global"
	Write-Host "[2] Universal"
	Write-Host "[3] DomainLocal"
	
	$var_groupscope=Read-Host "Please Select A Group Scope"
	Switch ($var_groupscope) {
		1 {Write-Host "`n You've Selected Global"; $var_groupscope= "Global"}
		2 {Write-Host "`n You've Selected Universal"; $var_groupscope= "Universal"}
		3 {Write-Host "`n You've Selected DomainLocal"; $var_groupscope= "DomainLocal"}
		}
		
	#Create Group -- Creates them on the ETN DC
	new-QADGroup -Service "prod-dum-dc1.prod.c2s2.l-3com.com" -ParentContainer "ou=Groups,ou=$var_site,ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -name "$var_groupname" -samaccountname "$var_groupname" -grouptype "$var_grouptype" -groupscope "$var_groupscope" -ObjectAttributes @{"mailnickname"="$var_groupname"}
}

Else {

#Enter Group Scope -- Acceptable values: 'Global'; 'Universal'; 'DomainLocal'.
	Write-Host "[1] Global"
	Write-Host "[2] Universal"
	Write-Host "[3] DomainLocal"
	
	$var_groupscope=Read-Host "Please Select A Group Scope"
	Switch ($var_groupscope) {
		1 {Write-Host "`n You've Selected Global"; $var_groupscope= "Global"}
		2 {Write-Host "`n You've Selected Universal"; $var_groupscope= "Universal"}
		3 {Write-Host "`n You've Selected DomainLocal"; $var_groupscope= "DomainLocal"}
		}
		
	#Create Group -- Creates them on the ETN DC
	new-QADGroup -Service "prod-dum-dc1.prod.c2s2.l-3com.com" -ParentContainer "ou=Groups,ou=$var_site,ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -name "$var_groupname" -samaccountname "$var_groupname" -grouptype "$var_grouptype" -groupscope "$var_groupscope"
}