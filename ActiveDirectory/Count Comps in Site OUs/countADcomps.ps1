$d1 = @("CSS","CSS","CSS","CSS","EOBU","EOBU","EOBU","EOBU","EOBU","EOBU","EOBU","FINANCE","MEBU","MEBU","MEBU","MEBU","MEBU","MEBU","MEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU","SAEBU")
$s1 = @("BEL","ETN","SHR","SIE","DUM","MIS","ORL","PAN","STA","STF","VAB","MAR","ARL","CHA","HAV","LEX","MIS","TOR","VAB","CAM","CHE","HOL","HOR","JAC","LEX","MAR","NOR","OCE","PTM","RID","UPP","VAB")
$f1 = @("Belcamp","Eatontown","Shrewsbury","Sierra Vista","Dumfries","Mission Valley","Orlando","Panama City","Stafford","Strafford-MKI","Virginia Beach","Mount Laurel-MOU","Arlington-Crystal City","Charleston","Havelock","Lexington Park","Mission Valley","Torry Pines","Viringia Beach","Camarillo","Chesapeake","Hollywood","Horsham","Jacksonville","Lexington Park","Mount Laurel-MOU","Norfolk","Oceana NAS","Point Mugu","Ridgecrest","Upper Malboro","Viringia Beach")


$ExcelSheet=new-object -comobject Excel.application    			#Creates excel com object
$WorkBook=$ExcelSheet.WorkBooks.add()                     		#when you first open excel it creates workbook
$ExcelSheet.visible=$true
$workbook.workSheets.item(3).delete()
$workbook.WorkSheets.item(2).delete()
$workbook.WorkSheets.item(1).Name = "Delete Me"

$WorkSheet=$WorkBook.WorkSheets.Add()                 		#Under book create a worksheet 



$WorkSheet.name = "Webroot Status"		
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
$WorkSheet.cells.item(1,5)=”Total AD”
$WorkSheet.cells.item(1,5).Interior.ColorIndex = 15
$WorkSheet.cells.item(1,5).font.bold = $True
$WorkSheet.cells.item(1,6)=”Total Webroot”
$WorkSheet.cells.item(1,6).Interior.ColorIndex = 15
$WorkSheet.cells.item(1,6).font.bold = $True
$WorkSheet.cells.item(1,8)=”Total % Complete”
$WorkSheet.cells.item(1,8).Interior.ColorIndex = 15
$WorkSheet.cells.item(1,8).font.bold = $True
$WorkSheet.cells.item(2,8)=”=F36/E36*100”
$WorkSheet.cells.item(2,8).font.bold = $True

$i=2
$ii=0
Foreach ($s in $s1){
$s2=$s1[$ii]
$d2=$d1[$ii]
$comps = get-qadcomputer -SearchRoot "ou=Computers,ou=$s2,ou=$d2,ou=ORG,dc=prod,dc=c2s2,dc=l-3com,dc=com"
$WorkSheet.cells.item($i,1)=”=F$i/E$i*100”
$s2=$s1[$ii]
$WorkSheet.cells.item($i,2)=”$s2"
$f2=$f1[$ii]
$WorkSheet.cells.item($i,3)=”$f2”
$d2=$d1[$ii]
$WorkSheet.cells.item($i,4)=”$d2”
$number=$comps.count
$WorkSheet.cells.item($i,5)=”$number”
$i=$i+1
$ii=$ii+1
}
$WorkSheet.cells.item($i,1)=”=F$i/E$i*100”
$WorkSheet.cells.item($i,2)=”XXX"
$WorkSheet.cells.item($i,3)=”Computers OU”
$WorkSheet.cells.item($i,4)=”XXX"
$comps = get-qadcomputer -SearchRoot "cn=Computers,dc=prod,dc=c2s2,dc=l-3com,dc=com"
$number=$comps.count
$WorkSheet.cells.item($i,5)=”$number”
$i=$i+1
$WorkSheet.cells.item($i,4)=”Total"
$WorkSheet.cells.item($i,5)=”=SUM(E2:E34)"
$WorkSheet.cells.item($i,6)=”=SUM(F2:F34)"
$WorkBookAutofit = $WorkSheet.UsedRange
$WorkBookAutofit.EntireColumn.AutoFit()

