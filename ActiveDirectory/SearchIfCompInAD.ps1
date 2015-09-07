$var_filename=Read-Host "Please Enter a File Name/Location"	
$readfile=get-content $var_filename
foreach($compname in $readfile){
	Get-QADComputer -SearchRoot "OU=CSS,OU=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" | Where-Object {$_.Name -eq $compname} |Format-Table -Property name | Out-File hosts.txt -append
								}