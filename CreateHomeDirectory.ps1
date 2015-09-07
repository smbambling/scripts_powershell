#Load Quest Active Directory Managment CMDLETs
if(Get-PSSnapin | Where-Object {$_.Name -eq "Quest.ActiveRoles.ADManageMent"}){Echo "CMDLETs Already Loaded"}
else {Add-PSSnapin Quest.ActiveRoles.ADManagement}

#Search All Useres in OU that don't have a home directory set
$users = Get-QADUser -SizeLimit 0 -SearchRoot "OU=Local,OU=Users,OU=ORL,OU=EOBU,OU=ORG,DC=prod,DC=c2s2,DC=l-3com,DC=com" | where-object {$_.homedirectory -eq $null}
$domain = "PROD"
$server = "prod-ORL-fs1"
$homesdir = "homes"


ForEach ($user in $users){
$user = $user.LogonName

#Set Directory
$directory = "\\$server\$homesdir\$user"

#Test To See If Directory Exist Already
if ((Test-Path -path $directory) -ne $True){

#Create Directory
mkdir $directory

#You need to have the $homes folder shared to Everyone but then remove the Everyone Group from the NTFS perms.

# Grant User Full Access To Folder
$inherit = [system.security.accesscontrol.InheritanceFlags]"ContainerInherit, ObjectInherit"
$propagation = [system.security.accesscontrol.PropagationFlags]"None"
$acl = Get-Acl $directory
$accessrule = New-Object system.security.AccessControl.FileSystemAccessRule("$domain\$user", "FullControl", $inherit, $propagation, "Allow")
$acl.AddAccessRule($accessrule)
set-acl -aclobject $acl $directory

#Delete Access Rule for account "Everyone"  -- For this to work you can't have inheritable permissions enabled for the user you want to remove
#$acl = Get-Acl $directory
#$accessrule = New-Object system.security.AccessControl.FileSystemAccessRule("PROD\da.sb", "Read", $inherit, $propagation, "Allow")
#$acl.RemoveAccessRuleAll($accessrule)
#set-acl -aclobject $acl $directory
	}
}
