#Load Quest Active Directory Managment CMDLETs
if(Get-PSSnapin | Where-Object {$_.Name -eq "Quest.ActiveRoles.ADManageMent"}){Echo "CMDLETs Already Loaded"}
else {Add-PSSnapin Quest.ActiveRoles.ADManagement}

# get domain maximumPasswordAge value
$MaxPassAge = (Get-QADObject (Get-QADRootDSE).defaultNamingContextDN).MaximumPasswordAge.days

if($MaxPassAge -le 0)
{ 
   throw "Domain 'MaximumPasswordAge' password policy is not configured."
} 

#Days untill users password expires
$DaysToExpire = 40

#Check users that have a password expiring in 14 days or less
Get-QADUser -SearchRoot "ou=DUM,ou=EOBU,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com" -Enabled -PasswordNeverExpires:$false -SizeLimit 0 -Email * | Select-Object Name,Email,@{Name="Expires";Expression={ $MaxPassAge - $_.PasswordAge.days }} | Where-Object {$_.Expires -gt 0 -AND $_.Expires -le $DaysToExpire }| Foreach-Object { 

#Send Email to user that password is going to expire
$SMTPserver = "prod-dum-xch1.prod.c2s2.l-3com.com"
$from = "noreply@l-3com.com"
$to = $_.Email
$subject = "Password reminder: Your Windows password will expire in $($_.Expires) days"
$emailbody = "Password reminder: Your Windows password will expire in $($_.Expires) days"

$mailer = new-object Net.Mail.SMTPclient($SMTPserver)
$msg = new-object Net.Mail.MailMessage($from, $to, $subject, $emailbody)
$mailer.send($msg) 

}