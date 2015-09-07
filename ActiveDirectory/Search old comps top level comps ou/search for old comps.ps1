Clear-Host

$var_dclist=get-qadcomputer -ComputerRole "DomainController" | Select-Object Name
#$var_dclist="prod-dum-dc1","prod-vab-dc3","prod-arl-dc1","prod-hor-dc1","prod-etn-dc1","prod-vab-dc2","prod-css-dc1","prod-cha-dc1","prod-sta-dc1","prod-mar-dc1","prod-cam-dc1","prod-mis-dc1","prod-top-dc1","prod-jac-dc1","prod-pan-dc1","prod-lex-dc1","prod-orl-dc1","prod-stf-dc1"


$threshold=$var_dclist.count

Clear-Host

	$compdays=Read-Host "`n Enter Minimum Computer Age In Days"

	Clear-Host
		
	$a1 = new-object system.collections.arraylist
	$a2 = new-object system.collections.arraylist
	Foreach ($var_dc in $var_dclist){
#	$dc=$var_dc.name
	$dc=$var_dc
	echo "Connecting to $dc"
	Connect-QADService -service "$dc"
	$limit = (get-date).AddDays(-$compdays).ToFileTime()
	$filter = "(&(objectcategory=computer)(|(lastLogonTimestamp<=$limit)(!(lastLogonTimestamp=*))))" 
	Get-QADComputer -SearchRoot "CN=Computers,dc=prod,dc=c2s2,dc=l-3com,dc=com" -ldapFilter $filter -SizeLimit 0 | Foreach-Object -process {$a1.add($_.name) | out-null}
#	get-qadcomputer -SearchRoot "ou=Computers,ou=$var_site,ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -IncludeAllProperties | Where-Object { $_.lastlogon -lt (get-date).AddDays(-$compdays) } | Foreach-Object -process {$a1.add($_.name) | out-null}
	disconnect-QADService
	}
	
	#copy $a1 into $a2
	$a1 | foreach-object{$a2.add($_)} | out-null
	Echo "The following Computers are $compdays +" | out-file stalecomputers.txt -append
	Echo "_______________________________________" | out-file stalecomputers.txt -append

	#now the interesting part
	for($i = 0; $i -lt $a1.count; $i++){  #outer loop
		#initialize/reset counter
		$count = 0
		
		for($j = 0; $j -lt $a2.count; $j++){
			
			if($a2[$j] -eq $a1[$i]){
				#remove the matching item
				$a2.removeAt($j)
				#increment counter
				$count++
				#decrement array index to compensate for removed item
				$j--
			}
		}
		#threshold check
		
		if($count -ge $threshold){
			#output name to file
			$a1[$i] | out-file stalecomputers.txt -append
			$a1[$i] + " Is stale on $count DC's " | write-host
		}
	} #end of outer loop




