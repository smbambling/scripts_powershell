Clear-Host
$var_location=get-location
set-alias psexec "$var_location\psexec.exe"

#####################################################
#			Remote Push w/ PSEXEC.exe				#
#													#
#			Created by Steven Bambling				#
#####################################################

write-host "`n`n`t`t Remote Push Instalation `n`n"	

$var_user = Read-Host "Enter a username"
$var_password = read-host "Please Enter Your Password" -assecurestring
$BasicString = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($var_password)
$var_password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BasicString)
echo "`n Generating Site List"
$sites = New-Object system.collections.arraylist 
$sites.add("BLANK") | Out-Null
$sites.add("ARL") | Out-Null
$sites.add("CAM") | Out-Null
$sites.add("CHA") | Out-Null
$sites.add("DUM") | Out-Null
$sites.add("BEL") | Out-Null
$sites.add("CHE") | Out-Null
$sites.add("ETN") | Out-Null
$sites.add("HAV") | Out-Null
$sites.add("HOL") | Out-Null
$sites.add("NOR") | Out-Null
$sites.add("OCE") | Out-Null
$sites.add("PTM") | Out-Null
$sites.add("RID") | Out-Null
$sites.add("SHR") | Out-Null
$sites.add("SIE") | Out-Null
$sites.add("UPP") | Out-Null
$sites.add("VBW") | Out-Null
$sites.add("HOR") | Out-Null
$sites.add("JAC") | Out-Null
$sites.add("LEX") | Out-Null
$sites.add("MOU") | Out-Null
$sites.add("MIS") | Out-Null
$sites.add("ORL") | Out-Null
$sites.add("PAN") | Out-Null
$sites.add("STA") | Out-Null
$sites.add("STF") | Out-Null
$sites.add("TOR") | Out-Null
$sites.add("VAB") | Out-Null



for($i=1;$i -lt 28 ;$i++){
	Write-Host `t $i") " $sites[$i] `t ($i+1)") " $sites[$i+1]
	$i++	}

$var_site=Read-Host "`n Select A Site #"
	$site= $sites[$var_site]
	Switch ($var_site) {
	1 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\CEGCCFP3\C2S2DP"}     	 #ARL
	2 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\PROD-CAM-FS1\C2S2DP"}    	 #CAM
	3 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\AMS-CE-CH-FS1\C2S2DP"}     #CHA
	4 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\PROD-DUM-FS1\C2S2DP"}    	 #DUM
	5 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}    	 #BEL
	6 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}     			#CHE
	7 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\FS1\C2S2DP"}     #ETN
	8 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}     #HAV
	9 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}     #HOL
	10 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}     #NOR
	11 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}     #OCE
	12 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}     #PTM
	13 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}     #RID
	14 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}     #SHR
	15 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}     #SIE
	16 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}     #UPP
	17 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\See ETN\C2S2DP"}     #VBW
	18 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\PROD-HOR-BKP2\C2S2DP"}     #HOR
	19 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\JAX-FS1\C2S2DP"}     #JAC
	20 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\LEX-IT\C2S2DP"}     #LEX
	21 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\AMS-MAR-FS1\C2S2DP"}     #MOU
	22 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\MIMVTSDFS\C2S2DP"}     #MIS
	23 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\PROD-ORL-FS1\C2S2DP"}     #ORL
	24 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\MIPCFS1\C2S2DP"}     #PAN
	25 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\AMS-MI-STAF-FPS1\C2S2DP"}     #STA
	26 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\PROD-STF-FS1\C2S2DP"}     #STF
	27 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\ESD-FILE2\C2S2DP"}     #TOR
	28 {Write-Host "`n You've Selected $site -- Getting List Of Available Applications";$var_distropoint="\\PROD-VAB-FS6\C2S2DP"}     #VAB
	default {Write-Host "You didn't select a correct site"; exit}
			}

	net use $var_distropoint $var_password /USER:$var_user /persistent:no | out-null
	start-sleep -s 5
	net use $var_distropoint /delete | out-null

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
	$var_comp=Read-Host "Enter a Computer Name"	
		$ALive=get-wmiobject win32_pingstatus -Filter "Address='$var_comp'"
		if($ALive.statuscode -eq 0) {psexec -d -u $var_user -p $var_password \\$var_comp -c "$var_distropoint\$var_installfolder\$var_installer"}
					else{write-host $var_comp "is NOT reachable" -foreground "RED"; exit}
						}
			
IF ($var_list -eq "Y") {
	$var_filename=Read-Host "Please Enter a File Name/Location"					
	out-file hosts.txt
	$readfile=get-content $var_filename
	foreach($comp in $readfile){
		$ALive=get-wmiobject win32_pingstatus -Filter "Address='$comp'"
		if($ALive.statuscode -eq 0){$comp | Out-File hosts.txt -append}
		else{
			write-host $comp "is NOT reachable" -foreground "RED"
			$comp | Out-File failed.txt -append}
					}		
	$file = get-content hosts.txt
	foreach ($line in $file){psexec -d -u $var_user -p $var_password \\$line "$var_distropoint\$var_installfolder\$var_installer"}
					}
