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

Write-Host "`n`n`t`t Export Mailbox To PST `n`n"

#Variables
$path = "\\chaxch101.corp.contoso.net\PST"
$admin = [Environment]::UserName

$list=Read-Host "Do you want to read from a file? (Y/N)"
IF ($list -eq "N") { 
    $list=Read-Host "Do you want to export from a date range? (Y/N)"
        IF ($list -eq "N") { 
            	       $user = Read-Host "Enter A User Name"
           Add-MailboxPermission -Identity $user -User $admin -AccessRights  FullAccess
	       Export-Mailbox $user -PSTFolderPath $path\$user.pst -Confirm:$false
        } 
        IF ($list -eq "Y") {
	       $user = Read-Host "Enter A User Name"
           $start = Read-Host "Enter a Start Date MM/dd/YYYY"
           $end =  Read-Host "Enter a End Date MM/dd/YYYY"
           Add-MailboxPermission -Identity $user -User $admin -AccessRights  FullAccess
	       Export-Mailbox $user -StartDate "$start" -EndDate "$end" -PSTFolderPath $path\"$user"2.pst -Confirm:$false
        }    
}
IF ($list -eq "Y") {
    $file = Read-Host "Enter File Path/Name"
	$users = Get-Content $file
    $list=Read-Host "Do you want to export from a date range? (Y/N)"
    IF ($list -eq "N") { 
    	Foreach ($user in $users) {
           Add-MailboxPermission -Identity $user -User $admin -AccessRights  FullAccess
    	   Export-Mailbox $user -PSTFolderPath $path\$user.pst -Confirm:$false
	} 
        } 
        IF ($list -eq "Y") {
           $start = Read-Host "Enter a Start Date MM/dd/YYYY"
           $end =  Read-Host "Enter a End Date MM/dd/YYYY"
               	Foreach ($user in $users) {
                   Add-MailboxPermission -Identity $user -User $admin -AccessRights  FullAccess
            	   Export-Mailbox $user -StartDate "$start" -EndDate "$end" -PSTFolderPath $path\"$user"2.pst -Confirm:$false
	            }
        }    
}
