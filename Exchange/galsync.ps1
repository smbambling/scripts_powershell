### --- GALSYNC.PS1 ---
#
#  Written by Carol Wapshere
#
#  Manages contacts in two domains based on mail-enabled users in the other domain.
#	- Contacts are created for new users.
#	- Contacts are deleted if the source user no longer meets the filter requirements.
#	- Contacts are updated with changed information.
#
#  NOTES:
#   - Requires RSAT roles and features installed. Ref http://blogs.technet.com/heyscriptingguy/archive/2010/01/25/hey-scripting-guy-january-25-2010.aspx
#	- Attribute deletions are not replicated - only attribute adds and changes.
#   	- Requires Active Directory Web Services Gateway for Windows 2003 
#	- A user account is needed in each domain with permission to create contacts.
#	- The passwords for these user accounts must be stored in secure files using the command:
#		read-host -assecurestring | convertfrom-securestring | out-file C:\scripts\dom1cred.txt
#

### --- GLOBAL DEFINITIONS ---

$DOMAIN_1 = "gamma.contoso.net"
$DOMAIN_2 = "chadc01.corp.contoso.net"

#$OU_CONTACTS_1 = "OU=Domain2,OU=Contacts,DC=mydomain,DC=local"
$OU_CONTACTS_2 = "OU=ContactSync,DC=corp,DC=contoso,DC=net"

$USER_1 = "galsync@contoso.net"
$USER_2 = "srv.galsync@corp.contoso.net"

$PWFILE_1 = "C:\scripts\dom1cred.txt"
$PWFILE_2 = "C:\scripts\dom2cred.txt"

## The following list of attributes will be copied from User to Contact
$arrAttribs = 'company','givenName','mobile','postalAddress','postalCode','sn','st','streetAddress','telephoneNumber','title' ,'mail','c','co','l','facsimileTelephoneNumber','physicalDeliveryOfficeName'

## The following filter is used by Get-ADObject to decide which users will have contacts.
$strSelectUsers = 'ObjectClass -eq "user" -and homeMDB -like "*" -and -not userAccountControl -bor 2 -and -not msExchHideFromAddressLists -eq $true -and -not displayName -eq "Administrator"'

### --- FUNCTION TO ADD, DELETE AND MODIFY CONTACTS IN TARGET DOMAIN BASED ON SOURCE USERS ---

function SyncContacts
{
  PARAM($sourceDC, $sourceUser, $sourcePWFile, $targetDC, $targetUser, $targetPWFile, $targetOU)
  END
    {
	$colUsers = @()
	$colContacts = @()
	$colAddContact = @()
	$colDelContact = @()
	$colUpdContact = @()

	$arrUserMail = @()
	$arrContactMail = @()

	write-host "Enumerating..."

	### ENUMERATE USERS

	$password = get-content $sourcePWFile | convertto-securestring
	$sourceCred =  New-Object -Typename System.Management.Automation.PSCredential -Argumentlist $sourceUser,$password

	$colUsers = Get-ADObject -Filter $strSelectUsers -Properties * -Server $sourceDC -Credential $sourceCred

    if ($colUsers.Count -eq 0)
    {
        write-host "No users found in source domain!"
        break
    }

	foreach ($user in $colUsers)
	{
		$arrUserMail += $user.mail
	}

	### ENUMERATE CONTACTS

	$password = get-content $targetPWFile | convertto-securestring
	$targetCred =  New-Object -Typename System.Management.Automation.PSCredential -Argumentlist $targetUser,$password

	$colContacts = Get-ADObject -Filter 'objectClass -eq "contact"' -searchbase $targetOU -Server $targetDC -Credential $targetCred -Properties targetAddress

	foreach ($contact in $colContacts)
	{
		$strAddress = $contact.targetAddress -replace "SMTP:",""
		$arrContactMail += $strAddress
	}

	### FIND CONTACTS TO ADD AND UPDATE

	foreach ($user in $colUsers)
	{
		if ($arrContactMail -contains $user.mail)
		{
			write-host "Contact found for " $user.mail
			$colUpdContact += $user
		}
		else
		{
			write-host "No contact found for " $user.mail
			$colAddContact += $user
		}
	}

	### FIND CONTACTS TO DELETE

	foreach ($address in $arrContactMail)
	{
		if ($arrUserMail -notcontains $address)
		{
			$colDelContact += $address
			write-host "Contact will be deleted for " $address
		}
	}

	write-host ""
	write-host "Updating ...."

	### ADDS

	foreach ($user in $colAddContact)
	{
		write-host "ADDING contact for " $user.mail

		$hashAttribs = @{'targetAddress' = "SMTP:" + $user.mail}
		foreach ($attrib in $arrAttribs)
		{
			if ($user.$attrib -ne $null) { $hashAttribs.add($attrib, $user.$attrib) }
		}
		New-MailContact -Name $user.displayName -ExternalEmailAddress $user.mail -OrganizationalUnit "ContactSync"
		#New-ADObject -name $user.displayName -type contact -Path $targetOU -Description $user.description -server $targetDC -credential $targetCred -OtherAttributes $hashAttribs
	}

	### UPDATES

	foreach ($user in $colUpdContact)
	{
		write-host "VERIFYING contact for " $user.mail

		$strFilter = "targetAddress -eq ""SMTP:" + $user.mail + """"
		$colContacts = Get-ADObject -Filter $strFilter -searchbase $targetOU -server $targetDC -credential $targetCred -Properties *
		foreach ($contact in $colContacts)
		{
			$hashAttribs = @{}
			foreach ($attrib in $arrAttribs)
			{
				if ($user.$attrib -ne $null -and $user.$attrib -ne $contact.$attrib)
				{
					write-host "	Changing " $attrib
					write-host "		Before: " $contact.$attrib
					write-host "		After: " $user.$attrib
					$hashAttribs.add($attrib, $user.$attrib)
				}
			}
			if ($hashAttribs.Count -gt 0)
			{
				Set-ADObject -identity $contact -server $targetDC -credential $targetCred -Replace $hashAttribs
			}
		}

	}

	### DELETES

	foreach ($contact in $colDelContact)
	{
		write-host "DELETING contact for " $contact
		$strFilter = "targetAddress -eq ""SMTP:" + $contact + """"
		Get-ADObject -Filter $strFilter -searchbase $targetOU -server $targetDC -credential $targetCred | Remove-ADObject -server $targetDC -credential $targetCred -Confirm:$false
	}

  }
}

### --- MAIN ---

Start-Transcript galsync.log

if(@(get-module | where-object {$_.Name -eq "ActiveDirectory"} ).count -eq 0) {import-module ActiveDirectory}

write-host "DOMAIN1 Users --> DOMAIN2 Contacts"
SyncContacts -sourceDC $DOMAIN_1 -sourceUser $USER_1 -sourcePWFile $PWFILE_1 -targetDC $DOMAIN_2 -targetUser $USER_2 -targetPWFile $PWFILE_2 -targetOU $OU_CONTACTS_2

#write-host ""
#write-host "DOMAIN2 Users --> DOMAIN1 Contacts"
#SyncContacts -sourceDC $DOMAIN_2 -sourceUser $USER_2 -sourcePWFile $PWFILE_2 -targetDC $DOMAIN_1 -targetUser $USER_1 -targetPWFile $PWFILE_1 -targetOU $OU_CONTACTS_1

Stop-Transcript
