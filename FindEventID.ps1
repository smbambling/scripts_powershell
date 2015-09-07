## create connection

$connString = "Server=DEV-ETN-DB-01; Integrated Security=SSPI; Database=tempdb; Application Name=$ScriptName"

$sqlConn = new-object('System.Data.SqlClient.SqlConnection')
$sqlConn.ConnectionString = $connString
$sqlConn.Open()

# create command

$sqlCmd = new-object('System.Data.SqlClient.SqlCommand')
$sqlCmd.Connection = $sqlConn
$sqlCmd.CommandText = "SELECT @@version AS [Version], GetDate() AS [Timestamp]"

# execute command	(as scalar)
$ver = $sqlCmd.ExecuteScalar()

# display value
$ver

# execute command (as reader)

$data = $sqlCmd.ExecuteReader()

# display value
while ($data.Read()) {
	Write-Host $data.GetValue(0) -back white -fore black
	Write-Host $data.GetString($data.GetOrdinal("Version")) -back cyan -fore black
	Write-Host $data.GetValue(1) -back yellow -fore black
}

# close connection and clean up

$sqlConn.Close()

$sqlCmd = $null
$sqlConn = $null

### End Jasons Code

Clear-Host

$startTime = $(get-date).get_timeofday()            #start time, for script execution tracking
$logtime = (get-date).AddMinutes(-1)
$logtimef = (get-date)


#$var_dclist=get-qadcomputer -ComputerRole "DomainController"
$var_dclist="prod-etn-dc1"

Echo "LogTime $logtime"
Echo "LogTimeF $logtimef"

	Foreach ($var_dc in $var_dclist){
#	$dc=$var_dc.name
	$dc=$var_dc
	echo "Connecting to $dc"
#    Get-EventLog -LogName "Security" -ComputerName "$dc.prod.c2s2.l-3com.com" -after $logtime -before $logtimef | Where-Object {$_.eventID -eq "624"} | Format-List -Property TimeWritten,Username,Message,Category
    Get-EventLog -LogName "Security" -ComputerName "$dc.prod.c2s2.l-3com.com"| Where-Object {$_.eventID -eq "624"} | Format-List -Property TimeWritten,Username,Message,Category

    }

# ********************************************************************
Function Get-Runtime ([System.TimeSpan] $startTime) {
    #get current time
    $endTime = $(get-date).get_timeofday()

    #calculate runtime
    $total = $endtime - $starttime

    $hours = $total.get_hours()
    $min =   $total.get_minutes()
    $sec =   $total.get_seconds()
    $mils =  $total.get_milliseconds()
    
    #display run time
    $runtime = "Runtime: $hours Hours, $min Minutes, $sec Seconds, $mils Milliseconds"
    $runtime
}
# ********************************************************************

Get-RunTime($startTime)
