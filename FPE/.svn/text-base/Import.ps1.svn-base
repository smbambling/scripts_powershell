$plocal = "C:\Scripts\TMG\Exports"
#Set Date Variables
$Date = Get-Date
$Date = Get-Date -Format M.d.yyyy
$cred = Get-Credential

#Remote Computer(s)
$comps = "chaxch04", "chaxch03", "chaxch06"

Foreach ($comp in $comps) {
	#Configure PSSession
	$session = New-PSSession -ComputerName $comp -credential $cred
	#Load FPE Snapin
	Invoke-Command -Session $session -ScriptBlock {Add-PSSnapin FSSPSSnapin}
	#Set Date Variables for File namgin
	Invoke-Command -Session $session -ScriptBlock {$Date = Get-Date}
	Invoke-Command -Session $session -ScriptBlock {$Date = Get-Date -Format M.d.yyyy}
	Copy-Item $plocal\"$Date"Settings.xml \\$comp\c$
	Invoke-Command -Session $session -ScriptBlock {Import-FseSettings -Path C:\"$Date"Settings.xml}
	Invoke-Command -Session $session -ScriptBlock {del C:\"$Date"Settings.xml}

	#Remove All Active PSSessions
	Remove-PSSession -Session $session
	}
