$CAS_ARRAY = "cas01"

$CASARRAY_INSTANCE = Get-ClientAccessArray | Where-Object {$_.Name -eq $CAS_ARRAY}

$CASARRAY_FQDN = $CASARRAY_INSTANCE.Fqdn

$CASARRAY_MEMBERS = $CASARRAY_INSTANCE.Members | Select-Object Name

Foreach ($CAS_SERVER in $CASARRAY_MEMBERS)
{
#	Get-ClientAccessServer -Identity $CAS_SERVER.Name | fl AutoDiscoverServiceInternalUri 
	
#	Get-OwaVirtualDirectory -Server $CAS_SERVER.Name | Select-Object Identity,InternalUrl
	
#	Get-EcpVirtualDirectory -Server $CAS_SERVER.Name | Select-Object Identity,InternalUrl

#	Get-ActiveSyncVirtualDirectory $CAS_SERVER.Name | Select-Object Identity,InternalUrl

#	Get-OabVirtualDirectory $CAS_SERVER.Name | Select-Object Identity,InternalUrl
	
	Get-WebServicesVirtualDirectory $CAS_SERVER.Name | Select-Object Identity,InternalUrl

	

}