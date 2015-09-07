$comps=@()
$readfile=get-content comps.txt
foreach($i in $readfile){
            Get-QADComputer $i | foreach-object {$_.osname} | Out-File os.txt -append
            }
