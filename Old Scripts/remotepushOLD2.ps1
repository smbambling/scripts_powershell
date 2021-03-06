Clear-Host
$var_location=get-location
set-alias psexec "$var_location\psexec.exe"

#####################################################
#			Remote Push w/ PSEXEC.exe				#
#													#
#			Created by Steven Bambling				#
#####################################################

write-host "`n`n`t`t Remote Push Instalation `n`n"	

$var_user=Read-Host "Enter a username"
$var_password = read-host "Please Enter Your Password" -assecurestring 
$BasicString = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($var_password)
$var_password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BasicString)
echo "`n Generating Site List"
$sites=@()
$readfile=get-content Sites.txt
foreach($i in $readfile){
            $sites+=$i
            }
Write-Host `n
for($i=1; $i -le($sites.length-1);$i++){
	Write-Host `t $i") " $sites[$i] `t ($i+1)") " $sites[$i+1]
	$i++	}

$var_site=Read-Host "`n Select A Site #"
	$site= $sites[$var_site]
	Switch ($var_site) {
	1 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\ams-mar-fs1\webrootdistropoint"}		#MAR
	2 {Write-Host "`n You've Selected $site -- Getting List OF Available Applications";$var_distropoint="\\ams-cam-fs1\webrootdistropoint"}		#CAM
	3 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\prod-etn-spy01\webrootdistropoint"}	#ETN
	4 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\141.199.129.30\webrootdistropoint"}	#LEX
	5 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\war-fs1\dp"}							#HOR
	6 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\ams-mi-staf-fps1\distropoint"}		#STA
	7 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\prod-vab-spy1\webrootdistropoint"}	#VAB
	default {Write-Host "You didn't select a correct site"; exit}
			}

	net use z: $var_distropoint $var_password /USER:$var_user /persistent:no | out-null
	start-sleep -s 5
	net use z: /delete | out-null

	$entries = Get-ChildItem $var_distropoint
		$n = 0
		foreach ($entry in $entries) {
		$n++
		Write-Host "`n `t $n> $entry"
		}	
	$var_file = Read-Host "`n Select An Application #"
	Write-Host `n You Selected $entries[$var_file -1].Name `n
	$var_installfolder=$entries[$var_file -1].Name
	$var_installer=Get-childitem $var_distropoint\$var_installfolder -filter *.bat

$var_list=Read-Host "Are Your Computer In List.txt (Y/N)"
IF ($var_list -eq "N") {			
	$var_computer=Read-Host "Enter a Computer Name"
		$var_check=Read-Host "`n Do you want to check host connectivity?"
		IF ($var_check -eq "N") {
			psexec -u $var_user -p $var_password \\$var_computer "$var_distropoint\$var_installfolder\$var_installer"
			}
		IF ($var_check -eq "Y") {	
			$ALive=get-wmiobject win32_pingstatus -Filter "Address='$var_computer'"
				if($ALive.statuscode -eq 0){psexec -u $var_user -p $var_password \\$var_computer "$var_distropoint\$var_installfolder\$var_installer"}		
			else{write-host $var_computer "is NOT reachable" -foreground "RED"; exit}
						}
					}
					
IF ($var_list -eq "Y") {
	$var_filename=Read-Host "Please Enter a File Name/Location"
	$var_check=Read-Host "`n Do you want to check host connectivity?"
	IF ($var_check -eq "N") {
		$file = get-content $var_filename
			foreach ($line in $file){psexec -d -u $var_user -p $var_password \\$line "$var_distropoint\$var_installfolder\$var_installer"}
							}
	IF ($var_check -eq "Y") {						
	out-file hosts.txt
	$readfile=get-content $var_filename
	foreach($readf in $readfile){
        $ALive=get-wmiobject win32_pingstatus -Filter "Address='$readf'"
		if($ALive.statuscode -eq 0){$readf | Out-File hosts.txt -append}
		else{
			write-host $readf "is NOT reachable" -foreground "RED"
			$readf | Out-File failed.txt -append}
					}		
	$file = get-content hosts.txt
	foreach ($line in $file){psexec -d -u $var_user -p $var_password \\$line "$var_distropoint\$var_installfolder\$var_installer"}
					}
	}
