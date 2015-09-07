function Get-FSMORoles
{
Param (
  $Domain
  )
  
  $DomainDN = $Domain.defaultNamingContext
  $SchemaDN = $Domain.schemaNamingContext
  $ConfigDN = $Domain.configurationNamingContext
  
  $FSMO = @{}
#  PDC Emulator
  $PDC  = [adsi]("LDAP://"+ $DomainDN)
  $FSMO  = $FSMO + @{"PDC" = $PDC.fsmoroleowner}
  
#  RID Master
  $RID  = [adsi]("LDAP://cn=RID Manager$,cn=system,"+$DomainDN)
  $FSMO  = $FSMO + @{"RID" = $RID.fsmoroleowner}
    
#  Schema Master
  $Schema  = [adsi]("LDAP://"+$SchemaDN)
  $FSMO  = $FSMO + @{"Schema" = $Schema.fsmoroleowner}
  
#  Infrastructure Master
  $Infra  = [adsi]("LDAP://cn=Infrastructure,"+$DomainDN)
  $FSMO  = $FSMO + @{"Infra" = $Infra.fsmoroleowner}
  
#  Domain Naming Master
  $DN    = [adsi]("LDAP://cn=Partitions,"+$ConfigDN)
  $FSMO  = $FSMO + @{"DN" = $DN.fsmoroleowner}
  return $FSMO
}

$Role = (Get-FSMORoles ([adsi]("LDAP://RootDSE")))

write-host "PDC:"    $Role.PDC.ToString().split(",")[1]
write-host "RID:"   $Role.RID.ToString().split(",")[1]
write-host "Schema:"  $Role.Schema.ToString().split(",")[1]
write-host "Infra:"    $Role.Infra.ToString().split(",")[1]
write-host "DN:"     $Role.DN.ToString().split(",")[1]