$cred = Get-Credential

$comp = "chaxch05"
$plocal = "C:\Scripts\TMG\Exports"

#Set Date Variables
$Date = Get-Date
$Date = Get-Date -Format M.d.yyyy

#Configure PSSession
$session = New-PSSession -ComputerName $comp -credential $cred

#Load FPE Snapin
Invoke-Command -Session $session -ScriptBlock {Add-PSSnapin FSSPSSnapin}
#Set Date Variables for File namgin
Invoke-Command -Session $session -ScriptBlock {$Date = Get-Date}
Invoke-Command -Session $session -ScriptBlock {$Date = Get-Date -Format M.d.yyyy}
#Export the FPE Settings to C:\
Invoke-Command -Session $session -ScriptBlock {Export-FseSettings -Path C:\"$Date"Settings.xml}
#Copy *settings.xml to CHAMGT01 File Share
Copy-Item \\$comp\c$\"$Date"Settings.xml $plocal
#Delete *settings.xml off of $comp
Invoke-Command -Session $session -ScriptBlock {del C:\"$Date"Settings.xml}
#Export the FPE Extended Options to CHAMGT01 File Share
Invoke-Command -Session $session -ScriptBlock {Get-FseExtendedOption -Name *} >> $plocal\"$Date"ExtendedSettings.txt


#Remove All Active PSSessions
Remove-PSSession -Session $session

