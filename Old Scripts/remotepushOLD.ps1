Clear-Host
set-alias psexec "C:\Users\steven.bambling\Desktop\Push Install\psexec.exe"

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

$sites=@()
$readfile=get-content Sites.txt
foreach($i in $readfile){
            $sites+=$i
            }
Write-Host `n
for($i=1; $i -le($sites.length-1);$i++){
	Write-Host `t $i") " $sites[$i] `t ($i+1)") " $sites[$i+1]
	$i++	}

$var_site=Read-Host "Select A Site"
	$site= $sites[$var_site]
	Switch ($var_site) {
	1 {Write-Host "`n You've Selected $site -- Getting List Avilable Installers"; $var_distropoint="\\ams-mar-fs1\webrootdistropoint"}
	2 {Write-Host "`n You've Selected $site -- Getting List Avilable Installers";$var_distropoint="\\ams-cam-fs1\webrootdistropoint"}
	3 {Write-Host "`n You've Selected $site -- Getting List Avilable Installers";$var_distropoint="\\prod-etn-spy01\webrootdistropoint"}
	4 {Write-Host "`n You've Selected $site -- Getting List Avilable Installers";$var_distropoint="\\141.199.129.30\webrootdistropoint"}
	5 {Write-Host "`n You've Selected $site -- Getting List Avilable Installers";$var_distropoint="\\war-fs1\webrootdistropoint"}
	6 {Write-Host "`n You've Selected $site -- Getting List Avilable Installers";$var_distropoint="\\ams-mi-staf-fps1\distropoint"}
	default {Write-Host "You didn't select a correct site"}
			}
	net use z: $var_distropoint $var_password /USER:$var_user /persistent:no | out-null
	start-sleep -s 5
	net use z: /delete | out-null
	get-childitem -recurse $var_distropoint -Include *.bat |ft -hideTableHeaders Name | Out-File file_list.txt
	$sites=@()
	$readfile=get-content file_list.txt
	foreach($i in $readfile){
            $sites+=$i
            }
	Write-Host
	for($i=1; $i -le($sites.length-3); $i++){Write-Host `t $i") " $sites[$i]}
	$var_file=Read-Host "Select A Install # to run"
		$installer= $sites[$var_file]
		Write-Host `n You Selected $installer

$var_list=Read-Host "Are Your Computer In List.txt (Y/N)"
IF ($var_list -eq "N") {			
	$var_computer=Read-Host "Enter a Computer Name"
	$ALive=get-wmiobject win32_pingstatus -Filter "Address='$var_computer'" | Select-Object statuscode
		if($ALive.statuscode -eq 0){psexec -u $var_user -p $var_password \\$var_computer "$var_distropoint\$installer"}		
	else{write-host $var_computer "is NOT reachable" -foreground "RED"; exit}
	}
IF ($var_list -eq "Y") {
	$var_filename=Read-Host "Please Enter a File Name/Location"
	out-file hosts.txt
	$readfile=get-content $var_filename
	foreach($readf in $readfile){
        $ALive=get-wmiobject win32_pingstatus -Filter "Address='$readf'" | Select-Object statuscode
		if($ALive.statuscode -eq 0){$readf | Out-File hosts.txt -append}
		else{
			write-host $readf "is NOT reachable" -foreground "RED"
			$readf | Out-File failed.txt -append}
					}
		
	$file = get-content hosts.txt
	foreach ($line in $file){psexec -u $var_user -p $var_password \\$line "$var_distropoint\$installer"}
					}
IF (test-path file_list.txt){del file_list.txt}
IF (test-path hosts.txt) {del hosts.txt}
IF (test-path failed.txt) {del failed.txt}