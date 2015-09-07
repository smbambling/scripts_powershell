#Load Quest Active Directory Managment CMDLETs
if(Get-PSSnapin | Where-Object {$_.Name -eq "Quest.ActiveRoles.ADManageMent"}){Echo "CMDLETs Already Loaded"}
else {Add-PSSnapin Quest.ActiveRoles.ADManagement}

Clear-Host

#$var_dclist=get-qadcomputer -ComputerRole "DomainController"
$var_dclist="prod-dum-dc1","prod-vab-dc3","prod-arl-dc1","prod-hor-dc1","prod-etn-dc1","prod-vab-dc2","prod-css-dc1","prod-cha-dc1","prod-sta-dc1","prod-mar-dc1","prod-cam-dc1","prod-mis-dc1","prod-top-dc1","prod-jac-dc1","prod-pan-dc1","prod-lex-dc1","prod-orl-dc1","prod-stf-dc1"
#$var_dclist="prod-dum-dc1","prod-vab-dc3"

Echo "Buiness Units"
Echo "_____________"

get-qadobject -SearchRoot "ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -SearchScope 'OneLevel' | Foreach-Object -process {$_.name}

$var_bu=Read-Host "`nSelect A Business Unit"

Clear-Host

Echo "Sites"
Echo "_____"

get-qadobject -SearchRoot "ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -SearchScope 'OneLevel' | Foreach-Object -process {$_.name}

$var_site=Read-Host "`nSelect A Site"

Clear-Host

$var_list=Read-Host "Are Your Computer In List.txt (Y/N)"
IF ($var_list -eq "N") {

	#Connect to PROD-ETN-DC1
	Connect-QADService -service prod-etn-dc1 | Out-Null
	
	#Verify Computer Doesn't Exist In AD
	$compname = Read-Host "Enter Computer Name"
	$comptest = Get-QADComputer -SizeLimit 0 -SearchRoot "DC=prod,DC=c2s2,DC=l-3com,DC=com" | Where-Object {$_.Name -eq "$compname"}
	$comptest = $comptest.Name
	If ( $compname -eq $comptest) {Echo "$compname Already In AD" }
	Else{
	#Create Computer In AD
	New-QADObject -service 'prod-etn-dc1' -ParentContainer "OU=Computers,ou=$var_site,ou=$var_bu,ou=ORG,DC=prod,DC=c2s2,DC=l-3com,DC=com" -Type 'computer' -Name "$compname" -ObjectAttributes @{sAMAccountName="$compname"}

	
	#Enable Computer Account
	$uac = Get-QADComputer -SearchRoot "ou=Computers,ou=$var_site,ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -LdapFilter "(cn=$compname)" | select userAccountControl
	Get-QADComputer -SearchRoot "ou=Computers,ou=$var_site,ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -LdapFilter "(cn=$compname)" | Set-QADObject -objectAttributes @{userAccountControl=$uac.useraccountcontrol -bxor 2}
	
	#Disconnect From AD
	disconnect-QADService
						}
	}
IF ($var_list -eq "Y") {
	$var_filename=Read-Host "Please Enter a File Name/Location"	
	$readfile=get-content $var_filename
	foreach($compname in $readfile){
	
			#Connect to PROD-ETN-DC1
			Connect-QADService -service prod-etn-dc1 | Out-Null
			
			#Verify Computer Doesn't Exist In AD
			$comptest = Get-QADComputer -SizeLimit 0 -SearchRoot "DC=prod,DC=c2s2,DC=l-3com,DC=com" | Where-Object {$_.Name -eq "$compname"}
			$comptest = $comptest.Name
				If ( $compname -eq $comptest) {Echo "$compname Already In AD" }
					Else{
					#Create Computer In AD
					New-QADObject -service 'prod-etn-dc1' -ParentContainer "OU=Computers,ou=$var_site,ou=$var_bu,ou=ORG,DC=prod,DC=c2s2,DC=l-3com,DC=com" -Type 'computer' -Name "$compname" -ObjectAttributes @{sAMAccountName="$compname"}
					
					#Connect to PROD-ETN-DC1
					Connect-QADService -service prod-etn-dc1 | Out-Null
					
					#Enable Computer Account
					$uac = Get-QADComputer -SearchRoot "ou=Computers,ou=$var_site,ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -LdapFilter "(cn=$compname)" | select userAccountControl
					Get-QADComputer -SearchRoot "ou=Computers,ou=$var_site,ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -LdapFilter "(cn=$compname)" | Set-QADObject -objectAttributes @{userAccountControl=$uac.useraccountcontrol -bxor 2}
					
					#Disconnect From AD
					disconnect-QADService
								}
							}
						}
					
