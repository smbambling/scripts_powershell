$d1 = @("CSS","CSS","CSS","CSS","CSS","EOBU","EOBU","EOBU","EOBU","EOBU","EOBU","EOBU","FINANCE","MEBU","MEBU","MEBU","MEBU","MEBU","MEBU","MEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU")
$s1 = @("BEL","ETN","MAR","SHR","SIE","DUM","MIS","ORL","PAN","STA","STF","VAB","MAR","ARL","CHA","HAV","LEX","MIS","TOR","VAB","CAM","CHE","HOL","HOR","JAC","LEX","MAR","NOR","OCE","PTM","RID","UPP","VAB")
$f1 = @("Belcamp","Eatontown","Mount Laurel-MOU","Shrewsbury","Sierra Vista","Dumfries","Mission Valley","Orlando","Panama City","Stafford","Strafford-MKI","Virginia Beach","Mount Laurel-MOU","Arlington-Crystal City","Charleston","Havelock","Lexington Park","Mission Valley","Torry Pines","Viringia Beach","Camarillo","Chesapeake","Hollywood","Horsham","Jacksonville","Lexington Park","Mount Laurel-MOU","Norfolk","Oceana NAS","Point Mugu","Ridgecrest","Upper Malboro","Viringia Beach")

#$d1 = @("EOBU","EOBU","EOBU","EOBU")
#$s1 = @("DUM","ORL","STF","VAB")
#$f1 = @("Dumfries","Orlando","Stafford-MKI","Virginia Beach")

$ExcelSheet=new-object -comobject Excel.application    			#Creates excel com object
$WorkBook=$ExcelSheet.WorkBooks.add()                     		#when you first open excel it creates workbook
$ExcelSheet.visible=$true
$workbook.workSheets.item(3).delete()
$workbook.WorkSheets.item(2).delete()
$workbook.WorkSheets.item(1).Name = "Delete Me"

$ii=0

Foreach ($d in $d1){
$s2=$s1[$ii]
$d2=$d1[$ii]

$comps = get-qadcomputer -SearchRoot "ou=Computers,ou=$s2,ou=$d2,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com"

$WorkSheet=$WorkBook.WorkSheets.Add()                 		#Under book create a worksheet 
$WorkSheet.name = "$d2-$s2"					#Name Worksheet
$WorkSheet.cells.item(1,1)=”Webroot Data”                            	#Creates first row basically heading
$WorkSheet.cells.item(1,1).Interior.ColorIndex = 15
$WorkSheet.cells.item(1,1).font.bold = $True
$WorkSheet.cells.item(1,2)=”Active Directory Export”                 	#Creates first row basically heading
$WorkSheet.cells.item(1,2).Interior.ColorIndex = 15
$WorkSheet.cells.item(1,2).font.bold = $True
$WorkSheet.cells.item(1,3)=”Webroot Installed”                       	#Creates first row basically heading
$WorkSheet.cells.item(1,3).Interior.ColorIndex = 15
$WorkSheet.cells.item(1,3).font.bold = $True
$WorkSheet.cells.item(1,4)=”Percentage Complete”                     	#Creates first row basically heading
$WorkSheet.cells.item(1,4).Interior.ColorIndex = 15
$WorkSheet.cells.item(1,4).font.bold = $True
$WorkSheet.cells.item(2,4)='=COUNTA(A2:A499)/COUNTA(B2:B498)*100'    	#Formual to find percentage complete
$WorkSheet.cells.item(2,4).font.bold = $True


$i=2
Foreach ($comp in $comps) {
$WorkSheet.cells.item($i,2)=$comp.Name
$WorkSheet.cells.item($i,3)="=IF(ISNA(VLOOKUP(B" + $i + "," + [char]36 + "A" + [char]36 + "2:" + [char]36 + "A" + [char]36 + "499,1,FALSE))," + [char]34 + "No" + [char]34 + "," + [char]34 + "Yes" + [char]34 + ")"
$i=$i+1
}

$ii=$ii+1
$WorkBookAutofit = $WorkSheet.UsedRange
$WorkBookAutofit.EntireColumn.AutoFit() 
}

$WorkSheet=$WorkBook.WorkSheets.Add()
$WorkSheet.name = "OverAll Status"
$WorkSheet.cells.item(1,1)=”% Complete”
$WorkSheet.cells.item(1,1).Interior.ColorIndex = 15
$WorkSheet.cells.item(1,1).font.bold = $True
$WorkSheet.cells.item(1,2)=”Site Code”
$WorkSheet.cells.item(1,2).Interior.ColorIndex = 15
$WorkSheet.cells.item(1,2).font.bold = $True
$WorkSheet.cells.item(1,3)=”Friendly Name”
$WorkSheet.cells.item(1,3).Interior.ColorIndex = 15
$WorkSheet.cells.item(1,3).font.bold = $True
$WorkSheet.cells.item(1,4)=”Business Unit”
$WorkSheet.cells.item(1,4).Interior.ColorIndex = 15
$WorkSheet.cells.item(1,4).font.bold = $True


$i=2
$ii=0
Foreach ($s in $s1){
$WorkSheet.cells.item($i,1)=”='$d2-$s2'!D2”
$s2=$s1[$ii]
$WorkSheet.cells.item($i,2)=”$s2"
$f2=$f1[$ii]
$WorkSheet.cells.item($i,3)=”$f2”
$d2=$d1[$ii]
$WorkSheet.cells.item($i,4)=”$d2”
$i=$i+1
$ii=$ii+1
}
$WorkBookAutofit = $WorkSheet.UsedRange
$WorkBookAutofit.EntireColumn.AutoFit() 
