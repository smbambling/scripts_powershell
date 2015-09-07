$complist = Get-QADComputer -SearchRoot "CN=Computers,dc=prod,dc=c2s2,dc=l-3com,dc=com" | format-table {$_.Name}
$compcount = "60"
$SMTPserver = "prod-dum-xch1.prod.c2s2.l-3com.com"
#$fileattachment = "c:\\boot.ini"
$from = "noreply@l-3com.com"
$to = "steven.bambling@l-3com.com"
$subject = "!IMPORTANT! Top Level Computers OU Cleanup"
$emailbody = "

All,

As of today the Top Level computers OU is back up to $compcount computers, we need everyone to take go back through these assets and double check to make sure that they are placed into the correct OU structure.  If computers are no longer in service please remove them from AD.  If you are uncomfortable  or unfamiliar and would like assistance please ask for assistance.

If you are unfamiliar with the current OU structure and have any questions please feel free to call me 703-445-8893

Below is a list of Computers that are currently in the Top Level Computers OU, please contact me to assist in moving these assets.


"

$mailer = new-object Net.Mail.SMTPclient($SMTPserver)
$msg = new-object Net.Mail.MailMessage($from, $to, $subject, $emailbody)
#$attachment = new-object Net.Mail.Attachment($fileattachment)
#$msg.attachments.add($attachment)
$mailer.send($msg) 