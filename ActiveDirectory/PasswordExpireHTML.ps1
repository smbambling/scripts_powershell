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

#Check users that have a password expiring in 14 days or less

Get-ADUser -SearchBase (Get-ADRootDSE).defaultNamingContext -Filter {(Enabled -eq "True") -and (PasswordNeverExpires -eq "False") -and (mail -like "*")} -Properties * | Select-Object Name,SamAccountName,mail,@{Name="Expires";Expression={ $MaxPassAge - ((Get-Date) - ($_.PasswordLastSet)).days}} | Where-Object { $_.Expires -le $DaysToExpire } | ConvertTo-HTML | Set-Content C:\inetpub\wwwroot\passwordexpire.html