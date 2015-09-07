#Load Quest Active Directory Managment CMDLETs
if(Get-PSSnapin | Where-Object {$_.Name -eq "Quest.ActiveRoles.ADManageMent"}){Echo "CMDLETs Already Loaded"}
else {Add-PSSnapin Quest.ActiveRoles.ADManagement}

Clear-Host

#$var_dclist=get-qadcomputer -ComputerRole "DomainController"
$var_dclist="prod-dum-dc1","prod-vab-dc3","prod-arl-dc1","prod-hor-dc1","prod-etn-dc1","prod-vab-dc2","prod-css-dc1","prod-cha-dc1","prod-sta-dc1","prod-mar-dc1","prod-cam-dc1","prod-mis-dc1","prod-top-dc1","prod-jac-dc1","prod-pan-dc1","prod-lex-dc1","prod-orl-dc1","prod-stf-dc1"
#$var_dclist="prod-dum-dc1","prod-vab-dc3"

$threshold=$var_dclist.count

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

$var_uvsc=Read-Host "Do You Want To Search For Users or Computers?"

IF ($var_uvsc -eq "Users") {

	$userdays=Read-Host "`n Enter Minimum User Age In Days"

	Clear-Host

	echo "Exporting to File $var_site-$var_bu-oldusers.txt Please Wait"
	$a1 = new-object system.collections.arraylist
	$a2 = new-object system.collections.arraylist
	Foreach ($var_dc in $var_dclist){
#	$dc=$var_dc.name
	$dc=$var_dc
	echo "Connecting to $dc"
	Connect-QADService -service "$dc"
	$limit = (get-date).AddDays(-$userdays).ToFileTime()
	$filter = "(&(objectcategory=User)(|(lastLogonTimestamp<=$limit)(!(lastLogonTimestamp=*))))" 
	Get-QADUser -SearchRoot "ou=Users,ou=$var_site,ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -ldapFilter $filter -SizeLimit 0 | Foreach-Object -process {$a1.add($_.name) | out-null}
#	get-qaduser -SearchRoot "ou=Users,ou=$var_site,ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -IncludeAllProperties | Where-Object { $_.lastlogon -lt (get-date).AddDays(-$userdays) } | Foreach-Object -process {$a1.add($_.name) | out-null}
	disconnect-QADService
	}
	#copy $a1 into $a2
	$a1 | foreach-object{$a2.add($_)} | out-null
	echo "The following Users have not logged into the domain in $userdays + days" | out-file $var_site-$var_bu-staleusers.txt -append
	Echo "_______________________________________________________________________" | out-file $var_site-$var_bu-staleusers.txt -append
	
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
		if($count -ge 2){
			#output name to file
			$a1[$i] | out-file $var_site-$var_bu-staleusers.txt -append
			$a1[$i] + " Is stale on $count DC's " | write-host
		}
	} #end of outer loop
}

IF ($var_uvsc -eq "Computers") {
	$compdays=Read-Host "`n Enter Minimum Computer Age In Days"

	Clear-Host
	
	echo "Exporting to File $var_site-$var_bu-oldcomps.txt Please Wait"
	
	$a1 = new-object system.collections.arraylist
	$a2 = new-object system.collections.arraylist
	Foreach ($var_dc in $var_dclist){
#	$dc=$var_dc.name
	$dc=$var_dc
	echo "Connecting to $dc"
	Connect-QADService -service "$dc"
	$limit = (get-date).AddDays(-$compdays).ToFileTime()
	$filter = "(&(objectcategory=computer)(|(lastLogonTimestamp<=$limit)(!(lastLogonTimestamp=*))))" 
	Get-QADComputer -SearchRoot "ou=Computers,ou=$var_site,ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -ldapFilter $filter -SizeLimit 0 | Foreach-Object -process {$a1.add($_.name) | out-null}
#	get-qadcomputer -SearchRoot "ou=Computers,ou=$var_site,ou=$var_bu,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -IncludeAllProperties | Where-Object { $_.lastlogon -lt (get-date).AddDays(-$compdays) } | Foreach-Object -process {$a1.add($_.name) | out-null}
	disconnect-QADService
	}
	
	#copy $a1 into $a2
	$a1 | foreach-object{$a2.add($_)} | out-null
	echo "The following Computers have not logged into the domain in $compdays + days" | out-file $var_site-$var_bu-stalecomputers.txt -append
	Echo "___________________________________________________________________________" | out-file $var_site-$var_bu-stalecomputers.txt -append
	
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
			$a1[$i] | out-file $var_site-$var_bu-stalecomputers.txt -append
			$a1[$i] + " Is stale on $count DC's " | write-host
		}
	} #end of outer loop
}



