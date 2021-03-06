<# HEADER
/*=====================================================================
Program Name            : Archive-Logs.ps1
Purpose                 : Script to archive log files from the previous
                          month.
Powershell Version:     : v2.0
Input Data              : N/A
Output Data             : Archive (7-zip) of selected files, then
                          original source files are deleted.

Originally Written by   : Scott Bass
Date                    : 01MAR2013
Program Version #       : 1.0

=======================================================================

Modification History    :

Programmer              : Scott Bass
Date                    : 12AUG2013
Change/reason           : Added -date parameter to specify an arbitrary
                          end date   
Program Version #       : 1.1

=====================================================================*/
#>

#region Parameters
[CmdletBinding(SupportsShouldProcess=$true)]
param(
   [datetime]$date
)
#endregion

#region Main
$ErrorActionPreference = "Continue"

# If date was specified use it, otherwise use today
if ($date) {$date=Get-Date $date} else {$date=Get-Date}

# Get desired date ranges
# We want all files from last month
$end   = (Get-Date $date -Day 1 -Hour 0 -Minute 0 -Second 0).AddMonths(-0) | Get-Date -format ddMMMyyyy
$start = (Get-Date $date -Day 1 -Hour 0 -Minute 0 -Second 0).AddMonths(-1) | Get-Date -format ddMMMyyyy

# Create prefix based on current yyyyMM
# Note: I did have a prefix based on current yyyy, but it made for huge archive files
$year   = (Get-Date $start -format yyyy)
$prefix = (Get-Date $start -format yyyyMM)

# Array of logs directories to process
$logDirs =
"BatchServer",
"ConnectSpawner",
"FrameworkServer",
"MetadataServer",
"ObjectSpawner",
"PooledWorkspaceServer",
"StoredProcessServer",
"WorkspaceServer"

# Array of log levels to process
$logLevels =
"Lev1",
"Lev2",
"Lev9"

# Use single quotes to delay resolution of embedded variables

# Root location for logs
$sasLogPath = 'E:\Logs\$lev\$logDir'

# Root location for APM logs
$apmLogPath = 'E:\SAS\APM93\ApmArchiveLog'

# Root location for archive files
$archiveRoot='T:\Logs\$lev\Archives\$year'

# Archive file name
$archiveName='$archiveRoot\$prefix - $logdir.7z'

# Archive log file name
$archiveLog='$archiveRoot\Archive-Logs.log'

# Function to archive the files
function ArchiveLogFiles {
   [CmdletBinding()]
   param (
      [String]$path,
      [String]$start,
      [String]$end,
      [String]$archive,
      [String]$log
   )

   # Catch errors so a failure or warning in one iteration won't halt the entire script
   Write-Host "Archiving $path..."
   try {
      Backup-Files -path $path -between $start,$end -recurse -archive $archive -log $archiveLog -append -withpath | Remove-Files -Verbose
   }
   catch {
      Write-Error "$_"
   }
   # Write-Host 'LASTEXITCODE=',$LASTEXITCODE
   # Write-Host '$?=',$?
   Write-Host ""
}

#####################################################################
# FOR DEBUGGING/TESTING...
#####################################################################
# Edit to suit the current data...
#$debug   = 1
#$start   = Get-Date 01jan2013
#$end     = Get-Date 01feb2013
#$year    = (Get-Date $start -format yyyy)
#$prefix  = (Get-Date $start -format yyyyMM)
#
#$logDirs =
#"MetadataServer"
#
#$logLevels =
#"Lev9"
#
#$archiveRoot='E:\Logs\$lev\Archives\$year'

#####################################################################
# END FOR DEBUGGING/TESTING...
#####################################################################

# Now loop over everything to archive the SAS logs
foreach ($lev in $logLevels) {
   foreach ($logDir in $logDirs) {
      # Use a script block + the invoke operator (&) to localize the variable scope
      & {
         $logPath=     (Invoke-Expression "Write-Output `"$sasLogPath`"")
         $archiveRoot= (Invoke-Expression "Write-Output `"$archiveRoot`"")
         $archiveName= (Invoke-Expression "Write-Output `"$archiveName`"")
         $archiveLog = (Invoke-Expression "Write-Output `"$archiveLog`"")

         if ($PSCmdlet.ShouldProcess(
            "`nLog Path:      $logPath`nStart:         $start`nEnd:           $end`nArchive Name:  $archiveName`nArchive Log:   $archiveLog`n`n","Archiving Logs"
         ))
         {
         	ArchiveLogFiles -path $logPath -start $start -end $end -archive $archiveName -log $archiveLog
		   }
      }
   }
}

if ($debug -eq 1) {return}

# Now the APM logs
foreach ($lev in "Lev1") {
   foreach ($logDir in "ApmArchiveLog") {
      # Use a script block + the invoke operator (&) to localize the variable scope
      & {
         $logPath=     (Invoke-Expression "Write-Output `"$apmLogPath`"")
         $archiveRoot= (Invoke-Expression "Write-Output `"$archiveRoot`"")
         $archiveName= (Invoke-Expression "Write-Output `"$archiveName`"")
         $archiveLog = (Invoke-Expression "Write-Output `"$archiveLog`"")

         if ($PSCmdlet.ShouldProcess(
            "`nLog Path:      $logPath`nStart:         $start`nEnd:           $end`nArchive Name:  $archiveName`nArchive Log:   $archiveLog`n`n","Archiving Logs"
         ))
         {
            ArchiveLogFiles -path $logPath -start $start -end $end -archive $archiveName -log $archiveLog
		   }
      }
   }
}
#endregion
