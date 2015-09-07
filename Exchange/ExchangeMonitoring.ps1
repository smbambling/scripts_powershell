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

# Get list of all the Mailbox Servers
$MBXS = Get-MailboxServer | Select-Object Name

# Get file with the last recorded Active Database Copy
$LASTMOUNT = Get-Content C:\ActiveDatabaseCopy.txt

# Check Mailbox Copy/Index Status
$MBXS | ForEach-Object { $MBXSTATUS = Get-MailboxDatabaseCopyStatus -Server $_.Name | Select Name,ActiveDatabaseCopy,Status,ContentIndexState

  If ( $MBXSTATUS.Status -notlike "Mounted" -And $MBXSTATUS.Status -notlike "Healthy" ) {

    $SMTPserver = "chaxch03.corp.contoso.net"

    $from = "noreply@contoso.net"

    $to = "admin@contoso.net"

    $subject = "Exchange Server $_.Name Mailbox Database Copy Status ERROR"

    $emailbody = "Server $_.Name has a mailbox copy status of $MBXSTATUS.Status
    
    This should be healthy or mounted and is not."

    $mailer = new-object Net.Mail.SMTPclient($SMTPserver)

    $msg = new-object Net.Mail.MailMessage($from, $to, $subject, $emailbody)

    $mailer.send($msg)
  }
  
  If ( $MBXSTATUS.ContentIndexState -notlike "Healthy" ) {

    $SMTPserver = "chaxch03.corp.contoso.net"

    $from = "noreply@contoso.net"

    $to = "admin@contoso.net"

    $subject = "Exchange Server $_.Name Mailbox Database Content Index State ERROR"

    $emailbody = "Server $_.Name has a mailbox copy status of $MBXSTATUS.ContentIndexState
    
    This should be healthy and is not."

    $mailer = new-object Net.Mail.SMTPclient($SMTPserver)

    $msg = new-object Net.Mail.MailMessage($from, $to, $subject, $emailbody)

    $mailer.send($msg)

  }

  If ( $MBXSTATUS.ActiveDatabaseCopy -notlike "$LASTMOUNT" ) {
  
    $SMTPserver = "chaxch03.corp.contoso.net"

    $from = "noreply@contoso.net"

    $to = "admin@contoso.net"

    $subject = "The Exchange Mailbox Database Mount Point Moved"

    $emailbody = "The Exchange Mailbox Datbase Mount Point has moved from $LASTMOUNT to $MBXSTATUS.ActiveDatabaseCopy"

    $mailer = new-object Net.Mail.SMTPclient($SMTPserver)

    $msg = new-object Net.Mail.MailMessage($from, $to, $subject, $emailbody)

    $mailer.send($msg)

  }
}

# Check MAPI Connectivity to MBX01

$MAPI = Test-MAPIConnectivity -Database MBX01 | Select-Object Result,Error

If ( $MAPI.Result -notlike "Success" ) {
  
  $SMTPserver = "chaxch03.corp.contoso.net"

  $from = "noreply@contoso.net"

  $to = "admin@contoso.net"

  $subject = "Exchange MAPI Connectivy to MBX01 Failed"

  $emailbody = "MAPI Connectivity Test to MBX01 failed with status of $MAPI.Error"

  $mailer = new-object Net.Mail.SMTPclient($SMTPserver)

  $msg = new-object Net.Mail.MailMessage($from, $to, $subject, $emailbody)

  $mailer.send($msg)

}

