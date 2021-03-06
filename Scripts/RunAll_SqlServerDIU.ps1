<# 
Header goes here...
#>

[CmdletBinding( SupportsShouldProcess = $true,
                ConfirmImpact = 'Medium' )]

param(
    # Tables to process
    [System.Array]
    $Tables
)

# Source the parameters
# (this may override some command line options)
. \\sascs\linkage\RL_content_snapshots\Powershell\Scripts\RunAll_SqlServerParametersDIU.ps1

###############################################################################
# MAIN PROCESSING
###############################################################################

$date=Get-Date -f "yyyyMMdd"

foreach ($table in $Tables) {
    $table=$table.ToUpper()
    
    # If the table is not defined print warning and return
    if ($ht.Get_Item($table) -eq $null) {
        Write-Warning "Table $table is not defined in the metadata.  Skipping..."
    } else {
        $dummy=Try {Stop-Transcript} Catch {}  # close any previously unclosed transcripts

        $transcript="\\sascs\linkage\RL_content_snapshots\Powershell\Logs\RLCS_dev_DataLoad_${table}_${date}.log"
        Start-Transcript $transcript
        
        \\sascs\linkage\RL_content_snapshots\Powershell\Scripts\RunAll_SqlServerBulkCopyDIU.ps1 -Tables $table
        \\sascs\linkage\RL_content_snapshots\Powershell\Scripts\RunAll_SqlServerPostProcessDIU.ps1 -Tables $table
        
        Try {Stop-Transcript} Catch {}
    }
}

### END OF FILE ###
