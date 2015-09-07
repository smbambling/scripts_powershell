#Load Quest Active Directory Managment CMDLETs
if(Get-PSSnapin | Where-Object {$_.Name -eq "Quest.ActiveRoles.ADManageMent"}){Echo "CMDLETs Already Loaded"}
else {Add-PSSnapin Quest.ActiveRoles.ADManagement}

$comps = Get-QADComputer -SearchRoot "OU=Servers,OU=TOR,OU=MEBU,OU=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" | foreach-object {$_.name}

Foreach ($comp in $comps){
$iis = get-wmiobject win32_service -filter "name='mssqlserver'" -computerName $comp

if($iis){
"$comp"
}
}