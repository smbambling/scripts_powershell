$domain = read-host "Please Enter Your FQDN"
$type = [System.DirectoryServices.ActiveDirectory.DirectoryContextType]::Domain
$context = New-Object -TypeName System.DirectoryServices.ActiveDirectory.DirectoryContext -ArgumentList $type, "$domain"
$dcs = [System.DirectoryServices.ActiveDirectory.DomainController]::FindAll($context)

foreach ($dc in $dcs){
    echo "Checking $dc.Name"
    $dc.Name | Out-File ReplicationStatus.txt -append
    echo "-----------------------------------" | Out-File ReplicationStatus.txt -append
    $dc.GetAllReplicationNeighbors() | Format-List PartitionName, SourceServer, LastAttemptedSync, LastSyncMessage | Out-File ReplicationStatus.txt -append
}
