#Load Exchange PS Snapin
if (@(Get-PSSnapin | Where-Object {$_.Name -eq "Microsoft.Exchange.Management.PowerShell.E2010"} ).count -eq 0) {Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010}

Get-Mailbox  | get-mailboxstatistics | select-object DisplayName,@{expression={$_.TotalItemSize.value.ToMB()};Name="Size"} | Sort -Property Size