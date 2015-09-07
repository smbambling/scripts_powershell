Function Get-ALLPropertyNames
{
param([string]$VariableName)
# Function that lists the properties
function Show-Properties
{
Param($BaseName)
If ((Invoke-Expression $BaseName) -ne $null)
{
$Children = (Invoke-Expression $BaseName) | Get-Member -MemberType Property
ForEach ($Child in ($Children | Where {$_.Name -ne “Length” -and $_.Name -notmatch “Dynamic[Property|Type]” -and $_.Name -ne “”}))
{
$NextBase = (“{0}.{1}” -f $BaseName, $Child.Name)
$Invocation = (Invoke-Expression $NextBase)
If ($Invocation)
{
If ($Invocation.GetType().BaseType.Name -eq “Array”)
{
# Recurse through subdir
$NextBase = $NextBase + ‘[0]‘
Show-Properties $NextBase
}
ElseIf ($Child.Definition -notlike “System*”)
{
# Recurse through subdir
Show-Properties $NextBase
}
Else
{
$myObj = “” | Select Name, Value
$myObj.Name = $NextBase
$myObj.Value = $Invocation
$myObj
}
}
Clear-Variable Invocation -ErrorAction SilentlyContinue
Clear-Variable NextBase -ErrorAction SilentlyContinue
}
}
Else
{
Write-Warning “Expand Failed for $BaseName”
}
}
# Actual start of script
If ((Invoke-Expression $VariableName).GetType().BaseType.Name -eq “Array”)
{
$VariableName = $VariableName + ‘[0]‘
}
Show-Properties $VariableName
}