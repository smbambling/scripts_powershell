$h = hostname

$fqdn = $h+".corp.contoso.net"

$cmd1 = "Set-ImapSettings -X509CertificateName $fqdn"

$cmd2 = "Set-PopSettings -X509CertificateName $fqdn"

Invoke-Expression -Command $cmd1 | out-null

$imapCheck = Get-ImapSettings

IF ($fqdn -eq $imapCheck.X509CertificateName) { Echo "Imap Settings Are Correctly Set" }

Invoke-Expression -Command $cmd2 | out-null

$popCheck = Get-ImapSettings

IF ($fqdn -eq $popCheck.X509CertificateName) { Echo "Pop Settings Are Correctly Set" }
