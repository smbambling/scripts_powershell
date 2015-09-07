#$readfile=get-content hosts.txt
#foreach($readf in $readfile)
#{
#$ALive=get-wmiobject win32_pingstatus -Filter "Address='$readf'" | Select-Object statuscode

#if($ALive.statuscode -eq 0)
#{write-host $readf is REACHABLE }
#else
#{write-host $readf is NOT reachable }
#}

$ip=read-host ”Enter IP or Hostname”
$ping = new-object System.Net.NetworkInformation.Ping
$rslt = $ping.send($ip)
if ($rslt.status.tostring() –eq “Success”) {
        write-host “ping worked”
}
else {
        write-host “ping failed”
}
