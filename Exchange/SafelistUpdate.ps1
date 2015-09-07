#Load Exchange PS Snapin
if (@(Get-PSSnapin | Where-Object {$_.Name -eq "Microsoft.Exchange.Management.PowerShell.E2010"} ).count -eq 0) {Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010}

#Initialize Array
$mailboxes = @()

#Populate Array
$mailboxes = Get-Mailbox | Where-Object {$_.Name -ne "Administrator" -and $_.Name -notlike "DiscoverySearchMailbox*"} | Select-Object Name

$date = Get-Date -Format Mdyyyy
$filepath = "C:\Scripts\Logs\Safelist-Update\$date.txt"
$time = Get-Date -Format hh:mm:ss

#Create Log File
Write-Output "Time: $time"`n"--------------" | Out-File $filepath -append
Write-Output "Updated SafeList For Users:"`n"--------------------------" | Out-File $filepath -append
 
#Run Update-Safelist Command for Each Mailbox
Foreach ($mailbox in $mailboxes){ 

Update-SafeList $mailbox.Name -Type Both

Write-Output $mailbox.Name | Out-File $filepath -append

}
Write-Output `n | Out-File $filepath -append

#Start Syncronization on Edge Servers
$edge = "CHAXCH03", "CHAXCH04"

Foreach ( $server in $edge) {

Start-EdgeSynchronization -Server $server | Out-Null
Write-Output "Started Syncroniztion on $server" | Out-File $filepath -append

}

Write-Output `n | Out-File $filepath -append