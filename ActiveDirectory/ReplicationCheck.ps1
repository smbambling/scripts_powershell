#Script Variables
$targetDC = "windc.contoso.net"
$sourceDC = "gamma.contoso.net"
$partDomain = "DC=contoso,DC=net"
$partSchema = "CN=Schema,CN=Configuration,DC=contoso,DC=net"
$partConfig = "CN=Configuration,DC=contoso,DC=net"
$domain = "contoso.net"
$type = [System.DirectoryServices.ActiveDirectory.DirectoryContextType]::Domain
$context = New-Object -TypeName System.DirectoryServices.ActiveDirectory.DirectoryContext -ArgumentList $type, "$domain"
$dcs = [System.DirectoryServices.ActiveDirectory.DomainController]::FindAll($context)

#Check if 64bit
function is64bit() {
  return ([IntPtr]::Size -eq 8)
}

#Create Program Files Variable
function get-programfilesdir() {
  if (is64bit -eq $true) {
    (Get-Item "Env:ProgramFiles(x86)").Value
  }
  else {
    (Get-Item "Env:ProgramFiles").Value
  }
}

#Set Program Files Variable
$programfiles = get-programfilesdir

If (Test-Path $programfiles'\Support Tools\repadmin.exe'){
	
	#Force AD Replation Function (This uses repadmin.exe from 2003 Support Tools)
	Function ForceReplication{
	& $programfiles'\Support Tools\repadmin.exe' /replicate $targetDC $sourceDC $partDomain
	& $programfiles'\Support Tools\repadmin.exe' /replicate $targetDC $sourceDC $partSchema
	& $programfiles'\Support Tools\repadmin.exe' /replicate $targetDC $sourceDC $partConfig
	}
	
	#Wait for 30 Seconds
	#for ($a=1; $a -lt 30; $a++) {
	#  Write-Progress -Activity "Waiting For AD Replication" -PercentComplete $a -CurrentOperation "$a% complete" -Status "Please wait."
	#  Start-Sleep 1
	#}
	
	#Get Replication Neighbor Data (Last Successful Sync Time)
	foreach ($dc in $dcs){
		If ($dc.Name -eq "windc.contoso.net"){
			$rep1 = $dc.GetAllReplicationNeighbors() | Where-Object{$_.SourceServer -eq "gamma.contoso.net" -and $_.PartitionName -eq $partDomain}
			$rep2 = $dc.GetAllReplicationNeighbors() | Where-Object{$_.SourceServer -eq "gamma.contoso.net" -and $_.PartitionName -eq $partSchema}
			$rep3 = $dc.GetAllReplicationNeighbors() | Where-Object{$_.SourceServer -eq "gamma.contoso.net" -and $_.PartitionName -eq $partConfig}
		}
	}
	
	#Compare Last Successfull Sync Time vs Current Time
	$check1 = (Get-Date) - $rep1.LastSuccessfulSync
	$check2 = (Get-Date) - $rep2.LastSuccessfulSync
	$check3 = (Get-Date) - $rep3.LastSuccessfulSync
	
	#Check to see if last Successfull Sync Time was longer then 30 secs ago...If true forec replication
	If ( $check1.seconds -gt 30 -or $check2.seconds -gt 30 -or $check3.seconds -gt 30  ) {echo "Forcing Replication"; ForceReplication}
	
	#Connect to GAMMA and get pwdLastSet Value then disconnect
	Connect-QADService -Service $sourceDC | Out-Null
	$ASH = Get-QadComputer -Name edamame -IncludedProperties pwdLastSet | Select-Object @{n="Days";e={((get-date)- $_.pwdLastSet).days}},@{n="Hours";e={((get-date)- $_.pwdLastSet).hours}},@{n="Minutes";e={((get-date)- $_.pwdLastSet).minutes}},@{n="Secconds";e={((get-date)- $_.pwdLastSet).seconds}}
	Disconnect-QADService
	
	#Connect to WINDC and get pwdLastSet Value then disconnecty
	Connect-QADService -Service $targetDC | Out-Null
	$DRP = Get-QadComputer -Name edamame -IncludedProperties pwdLastSet | Select-Object @{n="Days";e={((get-date)- $_.pwdLastSet).days}},@{n="Hours";e={((get-date)- $_.pwdLastSet).hours}},@{n="Minutes";e={((get-date)- $_.pwdLastSet).minutes}},@{n="Secconds";e={((get-date)- $_.pwdLastSet).seconds}}
	Disconnect-QADService
	
	#Compare the pwdLastSet Time on GAMMA and WINDC
	If($ASH.Days -eq $DRP.Days){
		IF($ASH.Hours -eq $DRP.Hours){
			If($ASH.Minutes -eq $DRP.Minutes){
				If($ASH.Seconds -eq $DRP.Seconds){Echo "Edamame pwdLastSet Attribute Matches on GAMMA and WINDC"  `n}ELSE {echo "Forcing Replication"; ForceReplication}
			}ELSE {Echo echo "Forcing Replication"; ForceReplication}
		}ELSE {Echo echo "Forcing Replication"; ForceReplication}
	}ELSE {Echo echo "Forcing Replication"; ForceReplication}
}
ELSE {Echo "Install Support Tools/REPADMIN missing" `n}	
