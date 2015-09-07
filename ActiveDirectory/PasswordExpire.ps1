#Active Directory Group Name To Be Edited
#Load Active Directory Module
if(@(get-module | where-object {$_.Name -eq "ActiveDirectory"} ).count -eq 0) {import-module ActiveDirectory}

# get domain maximumPasswordAge value

$MaxPassAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.days

if($MaxPassAge -le 0)

{ 

   throw "Domain 'MaximumPasswordAge' password policy is not configured."

} 

#Send Alert to User

$DaysToExpire = 14

$LogPath = "C:\Scripts\Logs\PasswordExpire"

#Create Daily Log File
$a=get-date -format "ddMMyyyy"
echo "Daily Log for $a" | Out-File $LogPath\$a.txt -append
echo "-----------------------" | Out-File $LogPath\$a.txt -append

#Check users that have a password expiring in 14 days or less

Get-ADUser -SearchBase (Get-ADRootDSE).defaultNamingContext -Filter {(Enabled -eq "True") -and (PasswordNeverExpires -eq "False") -and (mail -like "*")} -Properties * | Select-Object Name,SamAccountName,mail,@{Name="Expires";Expression={ $MaxPassAge - ((Get-Date) - ($_.PasswordLastSet)).days}} | Where-Object {$_.Expires -gt 0 -AND $_.Expires -le $DaysToExpire }| ForEach-Object {

If ( $_.mail -like "*@contoso.net" )
{ #Send Email to user that password is going to expire

$SMTPserver = "chaxch03.corp.contoso.net"

$from = "noreply@contoso.net"

$to = $_.mail

$subject = "Password reminder: Your Windows password will expire in $($_.Expires) days"

$emailbody = "Your Windows password for the account $($_.SamAccountName) will expire in $($_.Expires) days.

Windows Users:

Use either one of the options below:

1. Please press CTRL-ALT-DEL and click Change Password.
2. Using Outlook Web Access (OWA) you can change your password in a web browser by using the link: https://mail.corp.contoso.net/ecp/?rfr=owa&p=PersonalSettings/Password.aspx

Mac OS X Users:

Follow the instructions listed at http://confluence.contoso.net/Changing+Network+Password+on+Mac+OS+X


Please remember to also update your password everywhere that might use your credentials like your phone or instant messaging application. 

Passwords must contain 3 of the 4.

 - Upper Case
 - Lower Case
 - Numerical
 - Special Characters

In addition the password must be at least 8 characters long and they can not reuse their last 5 passwords.

If you need help changing your password please create a ticket by sending an email to helpdesk@contoso.net"


$mailer = new-object Net.Mail.SMTPclient($SMTPserver)

$msg = new-object Net.Mail.MailMessage($from, $to, $subject, $emailbody)

$mailer.send($msg) 

echo "$($_.Name) password will expire in $($_.Expires) days"  | Out-File $LogPath\$a.txt -append

}

If ( $_.mail -notlike "*@contoso.net" )
{ #Send Email to user that password is going to expire

$SMTPserver = "chaxch03.corp.contoso.net"

$from = "noreply@contoso.net"

$to = $_.mail

$subject = "Password reminder: Your CONTOSO password will expire in $($_.Expires) days"

$emailbody = "Your CONTOSO password for the account $($_.SamAccountName) will expire in $($_.Expires) days.  

For those on the CONTOSO AC please vist https://ac.contoso.net/cgi-bin/password.pl 

For those on the CONTOSO Board please visit https://board.contoso.net/cgi-bin/password.pl

For those on the NRO-CCG please visit https://nro-ccg.contoso.net/cgi-bin/password.pl

Passwords must contain 3 of the 4.

 - Upper Case
 - Lower Case
 - Numerical
 - Special Characters

In addition the password must be at least 8 characters long and they can not reuse their last 5 passwords.

If you need help changing your password please contact info@contoso.net"


$mailer = new-object Net.Mail.SMTPclient($SMTPserver)

$msg = new-object Net.Mail.MailMessage($from, $to, $subject, $emailbody)

$mailer.send($msg) 

echo "$($_.Name) password will expire in $($_.Expires) days"  | Out-File $LogPath\$a.txt -append

}

}

$ExpiredUsers = Get-ADUser -SearchBase (Get-ADRootDSE).defaultNamingContext -Filter {(Enabled -eq "True") -and (PasswordNeverExpires -eq "False") -and (mail -like "*")} -Properties * | Select-Object Name,SamAccountName,mail,@{Name="Expires";Expression={ $MaxPassAge - ((Get-Date) - ($_.PasswordLastSet)).days}} | Where-Object {$_.Expires -gt 0 -AND $_.Expires -le $DaysToExpire }

If ( $ExpiredUsers.count -gt 0 ) {

  $SMTPserver = "chaxch03.corp.contoso.net"

  $from = "noreply@contoso.net"

  $to = "admin@contoso.net"

  $subject = "Users with passwords that are going to expire in AD"

  $emailbody = Get-Content $LogPath\$a.txt | Out-String

  $mailer = new-object Net.Mail.SMTPclient($SMTPserver)

  $msg = new-object Net.Mail.MailMessage($from, $to, $subject, $emailbody)

  $mailer.send($msg)

} 

Else {

$SMTPserver = "chaxch03.corp.contoso.net"

$from = "noreply@contoso.net"

$to = "admin@contoso.net"

$subject = "Users with passwords that are going to expire in AD = NONE!"

$emailbody = "There are no users with passwords that are going to expire"

$mailer = new-object Net.Mail.SMTPclient($SMTPserver)

$msg = new-object Net.Mail.MailMessage($from, $to, $subject, $emailbody)

$mailer.send($msg)


}
