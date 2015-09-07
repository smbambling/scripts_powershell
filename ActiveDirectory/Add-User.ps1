#Load Active Directory Module
if(@(get-module | where-object {$_.Name -eq "ActiveDirectory"} ).count -eq 0) {import-module ActiveDirectory}
#Load Exchange PS Snapin
if (@(Get-PSSnapin | Where-Object {$_.Name -eq "Microsoft.Exchange.Management.PowerShell.E2010"} ).count -eq 0) {Add-PSSnapin Microsoft.Exchange.Management.PowerShell.E2010}

$var_usertype = Read-Host "What Account would you like to create?" `n "Internl,External,SUpport,SErvice "

If (($var_usertype -like "I") -or ($var_usertype -like "Internal")){ 
	$var_firstname = Read-Host "Enter First Name"
	$var_initials = Read-Host "Enter Middle Initial"
	$var_lastname = Read-Host "Enter Last Name"
	$var_logonname = Read-Host "Enter Logon Name"
	If (!$var_initials){$var_name = $var_firstname + " " + $var_lastname}
	Else {$var_name = $var_firstname + " " + $var_initials + "." + " " + $var_lastname}
	$var_upn = $var_logonname + "@corp.contoso.net"
	$var_primarysmtp = $var_logonname + "@contoso.net"
	$var_samaccountname = $var_logonname
	$var_alias = $var_logonname
	$var_displayname = $var_name
	$var_oupath = "OU=Internal,OU=Users,OU=CHA,DC=corp,DC=contoso,DC=net"
	
	$var_jobtitle = Read-Host "Enter Job Title"
	$var_address = "3635 Concorde Parkway, Suite 200"
	$var_state = "Virginia"
	$var_postalcode = "20151-1125"
	$var_city = "Chantilly"
	$var_department = Read-Host "Enter Department"
	$var_office = Read-Host "Enter Office"
	$var_officephone = Read-Host "Enter Office Phone Number Format: xxx-xxx-xxxx"
	
#New-Mailbox -Name $var_name -UserPrincipalName $var_upn -Alias $var_alias -DisplayName $var_displayname -Database MBX01 -FirstName $var_firstname -Initials $var_initials -LastName $var_lastname -OrganizationalUnit "Internal" -SamAccountName $var_samaccountname -ResetPasswordOnNextLogon $True -Confirm
 
New-ADUser -SamAccountName $var_samaccountname -AccountPassword (Read-Host -AsSecureString "AccountPassword") -Surname $var_firstname -Initials $var_initials -GivenName $var_lastname -DisplayName $var_displayname -UserPrincipalName $var_upn -Path $var_oupath -ChangePasswordAtLogon $true -Title "$var_jobtitle" -StreetAddress "$var_address" -City "$var_city" -State "$var_state" -PostalCode "$var_postalcode" -Department "$var_department" -Office "$var_office" $var_logonname -OfficePhone "$var_officephone"
}
	Elseif (($var_usertype -like "E") -or ($var_usertype -like "External")){ 
		echo "External" 
	}
		Elseif (($var_usertype -like "Su") -or ($var_usertype -like "Support")){ 
			echo "Support" 
		}
			Elseif (($var_usertype -like "SE") -or ($var_usertype -like "Service")){ 
				echo "Service" 
			}
		Else { Write-Host "Does not compute" }


