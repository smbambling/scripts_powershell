#Load Exchange PS Snapin
If (@(Get-PSSnapin -Registered | Where-Object {$_.Name -eq "Microsoft.Exchange.Management.PowerShell.E2010"} ).count -eq 1) {
    If (@(Get-PSSnapin | Where-Object {$_.Name -eq "Microsoft.Exchange.Management.PowerShell.E2010"} ).count -eq 0) {
         Write-Host "Loading Exchange Snapin Please Wait...."; Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010}
         } 

#Load Exchange PS Snapin
If (@(Get-PSSnapin -Registered | Where-Object {$_.Name -eq "Microsoft.Exchange.Management.PowerShell.Admin"} ).count -eq 1){ 
    If (@(Get-PSSnapin | Where-Object {$_.Name -eq "Microsoft.Exchange.Management.PowerShell.Admin"} ).count -eq 0) {
        Write-Host "Loading Exchange Snapin Please Wait...."; Add-PSSnapin Microsoft.Exchange.Management.PowerShell.Admin}
        }
		
$users = Get-Mailbox | Where-Object {$_.Name -ne "Administrator" -and $_.Name -notlike "DiscoverySearchMailbox*"}

foreach ($user in $users){
	$mod = Get-Mailbox -Identity $user
	$mod1 = $mod.alias
	If ($mod.emailAddresses -like "*X500:/o=First Organization/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Recipients/cn*"){
		Write-Host "Skipping $mod1"
	}
	Else {
		$mod2= $mod.emailAddresses + [Microsoft.Exchange.Data.CustomProxyAddress] ("X500:/o=First Organization/ou=Exchange Administrative Group (FYDIBOHF23SPDLT)/cn=Recipients/cn=$mod1")
		Set-Mailbox $mod1 -emailAddresses $mod2
	}
}