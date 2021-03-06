<?xml version="1.0" ?>
<xsl:transform version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <head>
<style type="text/css">
table, td, th
{
    border:1px solid black;
    text-align:center;
    vertical-align:bottom;
    padding: 3px;
	margin-right: 4px;
    margin-left: 4px;
    margin-bottom: 6px;
	margin-top: 6px;
    border-collapse:collapse;
	width: auto;
	background-color: rgb(255,255,255);
}
td.GuestVMReport
{
background-color: rgb(191,191,191);
}
th
{
background-color: rgb(141,180,227);
color:white;
}
th.TitleBar
{
background-color: rgb(55,96,145);
}
th.SubHeader
{
background-color: rgb(83,141,213);
}
th.LightGrayHeader
{
background-color: rgb(166,166,166);
}
th.DarkGrayHeader
{
background-color: rgb(128,128,128);
}

td.violation
{
background-color: rgb(150,54,52);
}
</style>
<Title>Guest VM Report</Title>
</head>
  <body>
<xsl:comment>Guest VM Report Container Table </xsl:comment>
<table align="center">
<tr><th class="TitleBar">Guest VM Report</th></tr>
<tr><td class="GuestVMReport">
<xsl:for-each select="/Objects/Object">
	<xsl:comment> VM Table </xsl:comment>
	<table align="center">
	<tr>
	  <th class="TitleBar" colspan="8"><xsl:value-of select="Property[@Name='Guest VM']"/></th>
	</tr>
	<tr><th>Virtual HW Version</th><th>Power State</th><th>vCPU Count</th><th>Memory</th><th>Provisioned Space</th><th>Host</th><th>DRS Configuration</th><th>HA Restart Priority</th></tr>
	<tr>
	  	<td><xsl:value-of select="Property[@Name='Virtual HW Version']"/></td>
      	<td><xsl:value-of select="Property[@Name='Power State']"/></td>
	  	<td><xsl:value-of select="Property[@Name='Number of vCPUs']"/></td>
		<td><xsl:value-of select="Property[@Name='Memory']"/></td>
		<td><xsl:value-of select="Property[@Name='Provisioned Space']"/></td>
		<td><xsl:value-of select="Property[@Name='Host']"/></td>
		<td><xsl:value-of select="Property[@Name='DRS Configuration']"/></td>
		<td><xsl:value-of select="Property[@Name='HA Restart Priority']"/></td>
	</tr>
	<tr><td colspan="8"><br />
	
		<xsl:comment> NIC Table </xsl:comment>
		<xsl:for-each select="descendant::Property[@Name='NICs']">
			<table align="center">
			<tr><th class="TitleBar" colspan="3">Virtual Network Interface Cards</th></tr>
			<tr><th>Type</th><th>MAC</th><th>Network Name</th></tr>
			<xsl:for-each select="descendant::Property[@Name='Type']">
				<tr>
	  			<td><xsl:value-of select="../Property[@Name='Type']"/></td>
      			<td><xsl:value-of select="../Property[@Name='MAC']"/></td>
	  			<td><xsl:value-of select="../Property[@Name='Network Name']"/></td>
				</tr>
			</xsl:for-each>
			</table><br />
		</xsl:for-each>
		<xsl:comment> End NIC Table </xsl:comment>

		<xsl:comment> Snapshot Summary Table </xsl:comment>
		<xsl:for-each select="descendant::Property[@Name='vmSnapInfo']">
			<table align="center">
			<tr><th class="TitleBar" colspan="5">Snapshot Summary</th></tr>
			<tr><th>Name</th><th>Description</th><th>Created</th><th>Is Current</th><th>Size</th></tr>
			<xsl:for-each select="descendant::Property[@Name='vmSnapName']">
				<tr>
	  			<td><xsl:value-of select="../Property[@Name='vmSnapName']"/></td>
      			<td><xsl:value-of select="../Property[@Name='vmSnapDescription']"/></td>
	  			<td><xsl:value-of select="../Property[@Name='vmSnapCreated']"/></td>
				<td><xsl:value-of select="../Property[@Name='vmSnapIsCurrent']"/></td>
				<td><xsl:value-of select="../Property[@Name='vmSnapSizeGB']"/></td>
				</tr>
			</xsl:for-each>
			</table><br />
		</xsl:for-each>
		<xsl:comment> End Snapshot Summary Table </xsl:comment>
		
		<xsl:comment> vDisks Table </xsl:comment>
		<table align="center">
		<tr><th class="TitleBar">Virtual Disks</th></tr><tr><td>
		<xsl:comment> vDisk Table </xsl:comment>
		<xsl:for-each select="descendant::Property[@Name='vDisks']">
			<xsl:for-each select="descendant::Property[@Name='Name']">
			<table align="center">
			<tr><th class="SubHeader" colspan="8"><xsl:value-of select="../Property[@Name='Name']"/></th></tr>
			<tr><th>Datastore</th><th>File</th><th>Thin</th><th>Raw Disk</th><th>Capacity</th><th>Allocated Capacity</th><th>Controller Type</th><th>Disk Mode</th></tr>
				<tr>
	  			<td><xsl:value-of select="../Property[@Name='Datastore']"/></td>
				<xsl:choose>
         			<xsl:when test="../Property[@Name='ViolatesNamingConvention']">
            			<td class="violation"><xsl:value-of select="../Property[@Name='File']"/><br />[Violates Naming Standard]</td>
          			</xsl:when>
          		<xsl:otherwise>
            		<td><xsl:value-of select="../Property[@Name='File']"/></td>
          		</xsl:otherwise>
        		</xsl:choose>

				<td><xsl:value-of select="../Property[@Name='Thin']"/></td>
				<td><xsl:value-of select="../Property[@Name='Raw Disk']"/></td>
				<td><xsl:value-of select="../Property[@Name='Capacity']"/></td>
				<td><xsl:value-of select="../Property[@Name='Allocated Capacity']"/></td>
				<td><xsl:value-of select="../Property[@Name='Controllertype']"/></td>
				<td><xsl:value-of select="../Property[@Name='Disk Mode']"/></td>

				</tr>
				<xsl:comment> Snapshots per vDisk Table </xsl:comment>
				<xsl:for-each select="../Property[@Name='SnapshotData']">
					<tr><td colspan="8"><table align="center">
					<tr><th class="DarkGrayHeader" colspan="8">vDisk Snapshot Data</th></tr>
					<xsl:for-each select="descendant::Property[@Name='SnapDiskName']">
						<tr><th class="LightGrayHeader">Name</th><th class="LightGrayHeader">Description</th><th class="LightGrayHeader">Datastore</th><th class="LightGrayHeader">File</th><th class="LightGrayHeader">Size</th><th class="LightGrayHeader">ID</th><th class="LightGrayHeader">Created</th><th class="LightGrayHeader">Quiesced</th></tr>
						<tr>
						<td><xsl:value-of select="../Property[@Name='SnapshotName']"/></td>
						<td><xsl:value-of select="../Property[@Name='SnapDescription']"/></td>
						<td><xsl:value-of select="../Property[@Name='SnapDatastore']"/></td>
						<td><xsl:value-of select="../Property[@Name='SnapFile']"/></td>
						<td><xsl:value-of select="../Property[@Name='SnapSize']"/></td>
						<td><xsl:value-of select="../Property[@Name='SnapID']"/></td>
						<td><xsl:value-of select="../Property[@Name='SnapCreateTime']"/></td>
						<td><xsl:value-of select="../Property[@Name='SnapQuiesced']"/></td>
						</tr>
					</xsl:for-each>
					</table></td></tr>
				</xsl:for-each>
				<xsl:comment> Snapshots per vDisk Table </xsl:comment>
			</table>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:comment> End vDisk Table </xsl:comment>
		</td></tr>
		</table>
		<xsl:comment> End vDisks Table </xsl:comment>

</td></tr></table><br />
</xsl:for-each>
<xsl:comment> End VM Table </xsl:comment>

</td></tr></table>
<xsl:comment> End Guest VM Report Container Table </xsl:comment>

</body>
</html>

</xsl:template>

</xsl:transform>