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
	
$users = Get-User | Where-Object {$_.Name -notlike "krbtgt_42596" -and $_.Name -notlike "krbtgt_61491" -and $_.Name -notlike "krbtgt" -and $_.Name -ne "Administrator" -and $_.Name -notlike "Guest" -and $_.Name -notlike "CONTOSO$" -and $_.Name -notlike "wlb_user" -and $_.Name -notlike "DiscoverySearchMailbox*"  -and $_.OrganizationalUnit -ne "corp.contoso.net/CHA/Users/Service" -and $_.OrganizationalUnit -ne "corp.contoso.net/CHA/Users/Support" -and  $_.OrganizationalUnit -ne "corp.contoso.net/CHA/Users/Term"} 

foreach($user in $users)
{
$dn = $user.DistinguishedName
$user=[ADSI]"LDAP://$dn"
$user.put("extensionAttribute1", "openfire")
$user.SetInfo()
}
