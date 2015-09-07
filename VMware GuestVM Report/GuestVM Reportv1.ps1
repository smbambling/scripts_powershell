Function test-NulltoString($In){
if ($In){$In.toString()}
else {"NA"}
}
Function Get-vDiskInfo($objVM){
Function Get-SubsetFromVMDKPath{
param(
[string]$VMDKPath,
[switch]$Datastore,
[switch]$Path
)
If ($Datastore){$Pattern = "(?imn)^\[(?<NG>.*)\].*"}
If ($Path){$Pattern ="(?imn)^.*\]\s(?<NG>.*)"}
[regex]$Regex = new-object System.Text.RegularExpressions.Regex($Pattern)
($Regex.Matches($VMDKPath)) | %{$_.Groups.Item("NG").Value}
}
Function Get-SnapshotInfo($SnapshotList){
	Process{
		$objSnapshotInfo = New-Object System.Object
		$objSnapshotInfo | Add-Member -type NoteProperty -Name "Name" -value $_.Name
		$objSnapshotInfo | Add-Member -type NoteProperty -Name "Description" -value $_.Description
		$objSnapshotInfo | Add-Member -type NoteProperty -Name "ID" -value $_.ID
		$objSnapshotInfo | Add-Member -type NoteProperty -Name "CreateTime" -value $_.CreateTime
		$objSnapshotInfo | Add-Member -type NoteProperty -Name "Quiesced" -value $_.Quiesced
		$objSnapshotInfo
		#Recurse through the guest VM's chain of snapshots
		if($_.ChildSnapShotList){$_.ChildSnapShotList | Get-SnapshotInfo}
	}
}

#Initialize objects before loop

$objAPIVM = $objVM | Get-View
$colvDiskInfo=@()

if ($objAPIVM.Snapshot){$SnapshotData = $objAPIVM.Snapshot.RootSnapshotList | Get-SnapshotInfo}

$colDevices = $objAPIVM.config.hardware.device | where {$_.deviceinfo.label -like "*hard disk*"}
foreach ($objDevice in $colDevices){
	$colDiskInfo = $objAPIVM.LayoutEx.Disk | Where {$_.Key -eq $objDevice.Key}
	foreach ($objDiskInfo in $colDiskInfo){
		#Grab the file chains for the virtual Disk, Each chain represents a pair of files (.vmdk / -flat.vmdk or -######.vmdk, ######-flat.vmdk)
		$DiskFileChains = $objDiskInfo | %{$_.Chain}
		#Calculate Base Disk Allocated Storage by adding the size of the file pairs
		$BaseDiskAllocatedStorage = 0
		$BaseDiskFileChainKeys = $DiskFileChains | Select-Object -First 1 | %{$_.Filekey} #Grab the Base Disk FileKeys From the First Disk Chain
		$objAPIVM.LayoutEx.File | where {$BaseDiskFileChainKeys -contains $_.Key} | %{$BaseDiskAllocatedStorage+=$_.size}
		#Get Snapshot Info
		if ($objAPIVM.Snapshot){
			$colSnapshotInfo=@()
			$i=1
			While (($i -le $objAPIVM.LayoutEx.Snapshot.Count) -and (($DiskFileChains.Count - $i) -gt 0)){
				$SnapshotFileKeys = ""
				$SnapshotSize = 0
				$SnapshotFileKeys = $DiskFileChains[($DiskFileChains.Count - $i)] | %{$_.FileKey}
				
				$objAPIVM.LayoutEx.File | where {$SnapshotFileKeys -contains $_.Key} | %{$SnapshotSize+=$_.size}
				#Build Snapshot Object
				$objSnapshotInfo = New-Object System.Object
				$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapDatastore" -value	(get-SubsetFromVMDKPath ($objAPIVM.LayoutEx.File | where {$_.key -eq $SnapshotFileKeys[0]} | %{$_.name}) -Datastore)
				$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapFile" -value (get-SubsetFromVMDKPath ($objAPIVM.LayoutEx.File | where {$_.key -eq $SnapshotFileKeys[0]} | %{$_.name}) -Path)
				$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapSize" -value (("{0:N2}" -f ($SnapshotSize/1GB)).tostring() + " GB")
				$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapDiskName" -value $objDevice.DeviceInfo.Label
					
				If ($SnapshotData -is [array]){
					$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapshotName" -value $SnapshotData[($objAPIVM.LayoutEx.Snapshot.Count - $i)].Name
					$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapDescription" -value $SnapshotData[($objAPIVM.LayoutEx.Snapshot.Count - $i)].Description
					$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapID" -value $SnapshotData[($objAPIVM.LayoutEx.Snapshot.Count - $i)].ID
					$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapCreateTime" -value $SnapshotData[($objAPIVM.LayoutEx.Snapshot.Count - $i)].CreateTime
					$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapQuiesced" -value $SnapshotData[($objAPIVM.LayoutEx.Snapshot.Count - $i)].Quiesced
				}
				else {
					$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapshotName" -value $SnapshotData.Name
					$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapDescription" -value $SnapshotData.Description
					$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapID" -value $SnapshotData.ID
					$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapCreateTime" -value $SnapshotData.CreateTime
					$objSnapshotInfo | Add-Member -type NoteProperty -Name "SnapQuiesced" -value $SnapshotData.Quiesced
				}
				#Add to Snapshot Collection For Disk
				$colSnapshotInfo += $objSnapshotInfo
				$i++;
			}
		}
		#Get Base Disk Chain / Full Name
		$DiskFullName = $objAPIVM.LayoutEx.File | where{$_.key -eq ($DiskFileChains | Select-Object -First 1 | %{$_.Filekey[0]})} | %{$_.name}
		$ControllerType=$objAPIVM.config.hardware.device | where{$_.key -eq $objDevice.ControllerKey} | %{$_.deviceinfo.Summary}

		#Build Output Object
		$objvDiskInfo = New-Object System.Object
			
		$objvDiskInfo | Add-Member -type NoteProperty -Name "Datastore" -value	(get-SubsetFromVMDKPath $DiskFullName -Datastore)
		$objvDiskInfo | Add-Member -type NoteProperty -Name "File" -value (get-SubsetFromVMDKPath $DiskFullName -Path)
		$objvDiskInfo | Add-Member -type NoteProperty -Name "Thin" -value $objDevice.Backing.ThinProvisioned
		$objvDiskInfo | Add-Member -type NoteProperty -Name "Capacity" -value (("{0:N2}" -f (($objDevice.CapacityInKB * 1KB) / 1GB)).tostring() + " GB")
		$objvDiskInfo | Add-Member -type NoteProperty -Name "Allocated Capacity" -value (("{0:N2}" -f ($BaseDiskAllocatedStorage/1GB)).tostring() + " GB")
		$objvDiskInfo | Add-Member -type NoteProperty -Name "Name" -value $objDevice.DeviceInfo.Label
		$objvDiskInfo | Add-Member -type NoteProperty -Name "Disk Mode" -value $objDevice.Backing.DiskMode
		$objvDiskInfo | Add-Member -type NoteProperty -Name "Controllertype" -Value $ControllerType
		$objvDiskInfo | Add-Member -type NoteProperty -Name "Raw Disk" -value $objDevice.Backing.gettype().Name.Contains("RawDisk")
		if ($colSnapshotInfo){
		$objvDiskInfo | Add-Member -type NoteProperty -Name "SnapshotData" -Value $colSnapshotInfo
		}
		if (!($objvDiskInfo.File.Contains($objVM.Name))){
		$objvDiskInfo | Add-Member -type NoteProperty -Name "ViolatesNamingConvention" -Value $True.ToString()
		}
		
		#Add to collection
		$colvDiskInfo += $objvDiskInfo
		
	}
}
$colvDiskInfo #Output Collection Object
}
Function get-vNICInfo($objVM){

$colvNICInfo = @()
 
	$objVM.NetworkAdapters | %{
	$objNICInfo = New-Object System.Object	
	$objNICInfo | Add-Member -type NoteProperty -Name "Type" -value	(test-nulltostring $_.Type)
	$objNICInfo | Add-Member -type NoteProperty -Name "Network Name" -value	$_.NetworkName
	$objNICInfo | Add-Member -type NoteProperty -Name "MAC" -value	$_.MacAddress
	$colvNICInfo+=$objNICInfo
	}
$colvNICInfo
}
Function get-vMSnapshotSummaryInfo($objVM){
$colvMSnapInfo = @()
 #Grabs Snapshot Info at the VM level as oppose to disk level
	$objVM | get-snapshot | %{
	$objvMSnap = New-Object System.Object	
	$objvMSnap | Add-Member -type NoteProperty -Name "vmSnapName" -value $_.Name
	$objvMSnap | Add-Member -type NoteProperty -Name "vmSnapDescription" -value $_.Description
	$objvMSnap | Add-Member -type NoteProperty -Name "vmSnapCreated" -value $_.Created
	$objvMSnap | Add-Member -type NoteProperty -Name "vmSnapIsCurrent" -value $_.IsCurrent
	$objvMSnap | Add-Member -type NoteProperty -Name "vmSnapSizeGB" -value (("{0:N2}" -f ($_.SizeMB/1024)).tostring() + " GB")
	$colvMSnapInfo += $objvMSnap
	}
$colvMSnapInfo | sort-object -property iscurrent,created -Descending
}
Function get-vMInfo($objVM){

$objvMInfo = New-Object System.Object
$objvMInfo | Add-Member -type NoteProperty -Name "Guest VM" -value	$objVM.Name
$objvMInfo | Add-Member -type NoteProperty -Name "Virtual HW Version" -value (test-nulltostring $objVM.Version)
$objvMInfo | Add-Member -type NoteProperty -Name "Power State" -value (test-nulltostring $objVM.PowerState)
$objvMInfo | Add-Member -type NoteProperty -Name "Number of vCPUs" -value $objVM.NumCpu
$objvMInfo | Add-Member -type NoteProperty -Name "Memory" -value (("{0:N2}" -f $objVM.MemoryMB).tostring() + " MB")
$objvMInfo | Add-Member -type NoteProperty -Name "DRS Configuration" -value (test-nulltostring $objVM.DRSAutomationLevel)
$objvMInfo | Add-Member -type NoteProperty -Name "HA Restart Priority" -value (test-nulltostring $objVM.HARestartPriority)
$objvMInfo | Add-Member -type NoteProperty -Name "Provisioned Space" -value (("{0:N2}" -f $objVM.ProvisionedSpaceGB).tostring() + " GB")
$objvMInfo | Add-Member -type NoteProperty -Name "vDisks" -value (get-vDiskInfo $objVM)
$objvMInfo | Add-Member -type NoteProperty -Name "NICs" -value (get-vNICInfo $objVM)
$objvMInfo | Add-Member -type NoteProperty -Name "Host" -value ((($objVM.Host.ToString()).tolower()).replace(".venable.com", ""))
$objVMSnapInfo = get-vMSnapshotSummaryInfo $objVM
if ($objVMSnapInfo){
$objvMInfo | Add-Member -type NoteProperty -Name "vmSnapInfo" -value $objVMSnapInfo
}

$objvMInfo
}

#---------------------------Begin Main----------------------
#---------------------------Begin Configuration----------------------
$VcenterServer = "vctr-hostname"
$XMLReportPath = ((Split-Path -parent $MyInvocation.MyCommand.Definition) + "\(" + ((get-date).ToString("yyyy-MM-dd hh-mm tt"))+ ") GuestVMReport.XML")
$XSLFileLocation = "guestvmreportv1.xsl"
#---------------------------End Configuration----------------------
Connect-VIServer $VcenterServer -cred (Get-Credential)
$GuestVMs = Get-VM | Sort-Object name

$OutputData = $GuestVMs | %{get-vMInfo $_}

$XML_Report = $OutputData | ConvertTo-Xml -as "document" -NoTypeInformation -depth 5
$XML_Stylesheet=$XML_Report.CreateProcessingInstruction("xml-stylesheet", "type=`"text/xsl`" href=`"" + $XSLFileLocation + "`"")
[Void]$XML_Report.insertafter($XML_Stylesheet, $XML_Report.firstchild)
$XML_Report.Save($XMLReportPath)