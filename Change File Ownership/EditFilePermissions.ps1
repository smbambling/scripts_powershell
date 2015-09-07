$usergiven = read-host "Enter FQDN User Name To Search File Ownership"
$usergrant = read-host "Enter FQDN User Name To Give File Ownership"

$Path = read-host "Enter Drive or Folder to Search EX: c:\"
$PathDir = get-Childitem $Path -recurse | Where {$_.psIsContainer -eq $false}
Write-Host "Files `t`t User `n"
Write-Host "----- `t`t ----"
Foreach ($file in $PathDir){
#    $owners = get-acl -path $file.fullname
	 $access = get-acl -path $file.fullname
	 $acls = $access.access
        Foreach ( $acl.IdentityReference in $acls){
            If ($acl.IdentityReference -like $usergiven){
             $control =  $acl.FileSystemRights
             $grant = $acl.AccessControlType
             $permission = "$usergrant","$control","$grant"
             $accessrule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
             $access.SetAccessRule($accessrule)
             $access | Set-Acl $file.fullname
             #Report Changed Files and New Owner
             Write-Host $file `t $usergrant `n
             
           }
        }
}
