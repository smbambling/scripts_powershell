# ********************************************************************
# Script Name:  Windows Hardlink Creater for MP4s
# Version:      2.3
# Author:       Arthur Jones
# Date:         27 July 2009
#
#revised Octavis Jones Aug 22 2009
#	~ changed extentions to mp4
#	~ replace --, " ",_ with hyphen
#	~ movie file to repo dir
# ********************************************************************

$startTime = $(get-date).get_timeofday()            #start time, for script execution tracking

# ********************************************************************

$var_repo = "R:\DVD_MP4\All Movies"
$var_twonky_az = "R:\DVD_MP4\A-Z"
$var_loc="C:\Documents and Settings\Administrator\Desktop\TO RIP"
$group = new-object -comobject System.Collections.ArrayList
$movies = new-object -comobject System.Collections.ArrayList
$updated = new-object -comobject System.Collections.ArrayList


##########################Phase 1################################
#Replace m4v extention with mp4
get-childitem $var_loc | where-object { $_.extension -eq ".m4v"} |%{Rename-Item $_ $($_.Name -replace".m4v",".mp4")} 

#store the list of .mp4 files in the repo directory
get-childitem $var_loc | where-object { $_.extension -eq ".mp4"} | foreach-object { $group.add($_)} | out-null

#loop through all .mp4 files
foreach ($movie in $group){%{Rename-Item $movie $($movie.Name.tolower() -replace "_","-" -replace " ","-" -replace "--","-")}}

############################Phase 2############################
#move mp4 to repository
write-host "Moving Files..."
get-childitem $var_loc | where-object { $_.extension -eq ".mp4"} | move-item -destination $var_repo
write-host "Moving complete..."


############################Phase 3############################
#store the list of .mp4 files in the repo directory
get-childitem $var_repo | where-object { $_.extension -eq ".mp4"} | foreach-object { $movies.add($_)} | out-null


#loop through all .mp4 files
foreach($movie in $movies) {
	#convert title to all lowercase
	$movie = $movie.name.tolower()
	
    #if movie contains "the-" ignore it
	if(($movie.Split('-')[0]) -eq "the"){
		$dest = $movie.toupper()[4]}
	else{
		#get the first character of the current mp4
		$dest = $movie.toupper()[0]}

	#special case: mp4's starting with a number
    if([int]$dest -lt 65){ $dest = "0-9"}
	
    if(!(test-path("$var_twonky_az\$dest"))){ #if the destination folder doesn't exist, create it
        new-item $var_twonky_az\$dest -type Directory | out-null
    }
    #create hardlink for each mp4
    if(!(test-path("$var_twonky_az\$dest\$movie"))){ #create hardlink if it doesnt already exist
        write-host "Updating `'$dest`' with $movie"	
        fsutil.exe hardlink create $var_twonky_az\$dest\$movie $var_repo\$movie | out-null
        $updated.add($movie) | out-null
    }
}

#clear-host

write-host "`n`n`t`t Updating Twonky Alphabetical Movie Folders A-Z `n`n"
write-host "The following have been updated:"
$updated | foreach-object {write-host "`t$_"}

write-host "`n`n`tUpdating Complete"

# ************************ Time Function ********************************
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

Get-RunTime($startTime)
write-host "`n"

