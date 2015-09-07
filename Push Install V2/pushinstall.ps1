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


$var_list=Read-Host "Are Your Computer In List.txt (Y/N)"
IF ($var_list -eq "N") {			
	$var_comp=Read-Host "Enter a Computer Name"	
		$ALive=get-wmiobject win32_pingstatus -Filter "Address='$var_comp'"
		if($ALive.statuscode -eq 0) {
		$oct1 = $ALive.IPV4Address.IPAddressToString | %{ $_.Split('.')[0]; }	
			if ($oct1 -eq "141"){
				$oct3 = $ALive.IPV4Address.IPAddressToString | %{ $_.Split('.')[2]; }
				$oct4 = $ALive.IPV4Address.IPAddressToString | %{ $_.Split('.')[3]; }
				Switch ($oct3) {
					139 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="CEGCCFP3";$var_distroname="ARL"}     	 	#ARL
					153 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="AMS-CE-CH-FS1";$var_distroname="CHA"}     #CHA
					148 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="PROD-DUM-FS1";$var_distroname="DUM"}    	#DUM
					202 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"}    	 		#BEL
					149 { Switch ($oct4) {
							128 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"} #CHE
							64 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"}  #NOR
							96 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"}  #OCE
							160 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"} #VBW
							32 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"} #RID
							}
						}
					190 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"}     #ETN
					191 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"}     #ETN
					152 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"}     #HAV
					130 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"}     #HOL
					189 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"}     #SHR					
					138 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"}     #UPP
					126 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="PROD-HOR-BKP2";$var_distroname="HOR"}     #HOR
					135 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="JAX-FS1";$var_distroname="JAC"}     #JAC
					129 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="LEX-IT";$var_distroname="LEX"}     #LEX
					128 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="LEX-IT";$var_distroname="LEX"}     #LEX
					131 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="LEX-IT";$var_distroname="LEX"}     #LEX
					133 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="AMS-MAR-FS1";$var_distroname="MOU"}     #MOU
					147 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="PROD-ORL-FS1";$var_distroname="ORL"}     #ORL
					142 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="MIPCFS1";$var_distroname="PAN"}     #PAN
					143 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="MIPCFS1";$var_distroname="PAN"}     #PAN
					141 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="MIPCFS1";$var_distroname="PAN"}     #PAN
					146 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="AMS-MI-STAF-FPS1";$var_distroname="STA"}     #STA
					134 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="PROD-STF-FS1";$var_distroname="STF"}     #STF
					155 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="PROD-VAB-FS6";$var_distroname="VAB"}     #VAB
					default {Write-Host "Site Not Found"; exit}
				}
			}
			elseif($oct1 -eq "159"){
				Switch ($oct3) {
					69 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="ESD-FILE2";$var_distroname="TOR"}     #TOR
					70 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="ESD-FILE2";$var_distroname="TOR"}     #TOR
					72 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="ESD-FILE2";$var_distroname="TOR"}     #TOR
					74 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="ESD-FILE2";$var_distroname="TOR"}     #TOR
					130 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="MIMVTSDFS";$var_distroname="MIS"}     #MIS
					131 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="MIMVTSDFS";$var_distroname="MIS"}     #MIS
					193 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="MIMVTSDFS";$var_distroname="MIS"}     #MIS
					199 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="MIMVTSDFS";$var_distroname="MIS"}     #MIS
					210 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"}     #SIE
					212 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="FS1";$var_distroname="ETN"}     #PTM
					134 {Write-Host "`n Getting List Of Available Applications";$var_distropoint="PROD-CAM-FS1";$var_distroname="CAM"}    	 #CAM
					default {Write-Host "Site Not Found"; exit}
				}
			}
			
		$entries = Get-ChildItem \\$var_distropoint\C2S2DP
		$n = 0
		foreach ($entry in $entries) {
			$n++
			Write-Host "`n `t $n> $entry"
			}	
		$var_file = Read-Host "`n Select An Application #"
		Write-Host `n You Selected $entries[$var_file -1].Name `n
		$var_installfolder=$entries[$var_file -1].Name
		$var_installer=Get-childitem \\$var_distropoint\C2S2DP\$var_installfolder -filter *.bat
		
		echo "$var_comp is installing from $var_distroname"
		psexec -d -u $var_user -p $var_password \\$var_comp -c -i "\\$var_distropoint\C2S2DP\$var_installfolder\$var_installer" | Out-Null
									}
					else{write-host $var_comp "is NOT reachable" -foreground "RED"; exit}
						}						
						
	
IF ($var_list -eq "Y") {
	$var_distropoint="\\PROD-DUM-FS1\C2S2DP"
	$entries = Get-ChildItem $var_distropoint
		$n = 0
		foreach ($entry in $entries) {
			$n++
			Write-Host "`n `t $n> $entry"
			}	
		$var_file = Read-Host "`n Select An Application #"
		Write-Host `n `t You Selected $entries[$var_file -1].Name `n
		$var_installfolder=$entries[$var_file -1].Name
		$var_installer=Get-childitem $var_distropoint\$var_installfolder -filter *.bat
	
	$var_filename=Read-Host "Please Enter a Host File Name/Location"
	#check if file exist, exit with message if does not.

	
	out-file hosts.txt
	$readfile=get-content $var_filename
	echo "`n Generating List For Reachable (hosts.txt) and Non-Reachable (failed.txt) Hosts"
	foreach($comp in $readfile){
		$ALive=get-wmiobject win32_pingstatus -Filter "Address='$comp'"
		if($ALive.statuscode -eq 0){$comp | Out-File hosts.txt -append;}
		else{
#			write-host $comp "is NOT reachable" -foreground "RED"
			$comp | Out-File failed.txt -append}
		}		
	$file = get-content hosts.txt
	foreach ($line in $file){
		$ALive=get-wmiobject win32_pingstatus -Filter "Address='$line'"
		$oct1 = $ALive.IPV4Address.IPAddressToString | %{ $_.Split('.')[0]; }	
			if ($oct1 -eq "141"){
				$oct3 = $ALive.IPV4Address.IPAddressToString | %{ $_.Split('.')[2]; }
				$oct4 = $ALive.IPV4Address.IPAddressToString | %{ $_.Split('.')[3]; }
				Switch ($oct3) {
					139 {$var_distropoint="CEGCCFP3";$var_distroname="ARL"}     	 	#ARL
					153 {$var_distropoint="AMS-CE-CH-FS1";$var_distroname="CHA"}     #CHA
					148 {$var_distropoint="PROD-DUM-FS1";$var_distroname="DUM"}    	#DUM
					202 {$var_distropoint="FS1";$var_distroname="ETN"}    	 		#BEL
					149 { Switch ($oct4) {
							128 {$var_distropoint="FS1";$var_distroname="ETN"} #CHE
							64 {$var_distropoint="FS1";$var_distroname="ETN"}  #NOR
							96 {$var_distropoint="FS1";$var_distroname="ETN"}  #OCE
							160 {$var_distropoint="FS1";$var_distroname="ETN"} #VBW
							32 {$var_distropoint="FS1";$var_distroname="ETN"} #RID
							}
						}
					190 {$var_distropoint="FS1";$var_distroname="ETN"}     #ETN
					152 {$var_distropoint="FS1";$var_distroname="ETN"}     #HAV
					130 {$var_distropoint="FS1";$var_distroname="ETN"}     #HOL
					189 {$var_distropoint="FS1";$var_distroname="ETN"}     #SHR					
					138 {$var_distropoint="FS1";$var_distroname="ETN"}     #UPP
					126 {$var_distropoint="PROD-HOR-BKP2";$var_distroname="HOR"}     #HOR
					135 {$var_distropoint="JAX-FS1";$var_distroname="JAC"}     #JAC
					129 {$var_distropoint="LEX-IT";$var_distroname="LEX"}     #LEX
					128 {$var_distropoint="LEX-IT";$var_distroname="LEX"}     #LEX
					131 {$var_distropoint="LEX-IT";$var_distroname="LEX"}     #LEX
					133 {$var_distropoint="AMS-MAR-FS1";$var_distroname="MOU"}     #MOU
					147 {$var_distropoint="PROD-ORL-FS1";$var_distroname="ORL"}     #ORL
					142 {$var_distropoint="MIPCFS1";$var_distroname="PAN"}     #PAN
					143 {$var_distropoint="MIPCFS1";$var_distroname="PAN"}     #PAN
					141 {$var_distropoint="MIPCFS1";$var_distroname="PAN"}     #PAN
					146 {$var_distropoint="AMS-MI-STAF-FPS1";$var_distroname="STA"}     #STA
					134 {$var_distropoint="PROD-STF-FS1";$var_distroname="STF"}     #STF
					155 {$var_distropoint="PROD-VAB-FS6";$var_distroname="VAB"}     #VAB
					default {Write-Host "Site Not Found"; exit}
				}
			}
			elseif($oct1 -eq "159"){
				Switch ($oct3) {
					69 {$var_distropoint="ESD-FILE2";$var_distroname="TOR"}     #TOR
					70 {$var_distropoint="ESD-FILE2";$var_distroname="TOR"}     #TOR
					72 {$var_distropoint="ESD-FILE2";$var_distroname="TOR"}     #TOR
					74 {$var_distropoint="ESD-FILE2";$var_distroname="TOR"}     #TOR
					130 {$var_distropoint="MIMVTSDFS";$var_distroname="MIS"}     #MIS
					131 {$var_distropoint="MIMVTSDFS";$var_distroname="MIS"}     #MIS
					193 {$var_distropoint="MIMVTSDFS";$var_distroname="MIS"}     #MIS
					199 {$var_distropoint="MIMVTSDFS";$var_distroname="MIS"}     #MIS
					210 {$var_distropoint="FS1";$var_distroname="ETN"}     #SIE
					212 {$var_distropoint="FS1";$var_distroname="ETN"}     #PTM
					134 {$var_distropoint="PROD-CAM-FS1";$var_distroname="CAM"}    	 #CAM
					default {Write-Host "Site Not Found"; exit}
				}
			}
		write-host "`t $line is installing from $var_distroname" -foreground "GREEN"
		psexec -d -u $var_user -p $var_password \\$line -c "\\$var_distropoint\C2S2DP\$var_installfolder\$var_installer" | Out-Null
		}
}