<#
THIS IS A PARAMETERS ONLY SCRIPT.
IT SETS THE PARAMETERS TO BE USED WITH OTHER SUPPORT SCRIPTS.
#>

<#
These parameters (mainly) match those of the SqlServerBulkCopy function
with appropriate defaults for the RunAll DUI tables functionality
The main difference is $Tables, which is an ArrayList, and not required.  
If not specified, all tables required by the DIU are run
(the table names are hard coded at the end of the script)
However, the defaults can be overridden on the command line,
for example to load the RLCS_prod database instead of RLCS_dev, 
or to re-load an individual table(s).
#>

<#
This string contains all the relevant tables for DIU.
Paste it into Powershell to create the local $Tables variable.
Edit as required, then invoke this script as <scriptname> -Tables $Tables

$Tables=@()

### APDC ###
$Tables+='HIRD_FORMATS'
$Tables+='HIRD_METADATA'

$Tables+='RLDXHOSP_AUDIT_TRAIL'
$Tables+='RLDXHOSP_OPERATIONAL'
$Tables+='RLDXHOSP_RECORD'

$Tables+='DIAGNOSIS'
$Tables+='EPISODE'
$Tables+='EPISODE_ATS'
$Tables+='EPISODE_DRG'
$Tables+='EPISODE_SRG'
$Tables+='FACILITY'
$Tables+='FACILITY_PEER_GROUP'
$Tables+='ISC_DIAGNOSIS'
$Tables+='ISC_EPISODE'
$Tables+='ISC_EPISODE_DRG'
$Tables+='ISC_PROCEDURE'
$Tables+='MEDPROC'
$Tables+='PATIENT_CONTACT_DETAILS'
$Tables+='REPLICA_ADDRESS_BOUNDARIES_ALL'
$Tables+='STAY'

$Tables+='EPISODE_NWAU'

$Tables+='AP_IDENTIFIED'

### EDDC ###
$Tables+='RLDXED_AUDIT_TRAIL'
$Tables+='RLDXED_OPERATIONAL'
$Tables+='RLDXED_RECORD'

$Tables+='ED_DIAGNOSIS'
$Tables+='ED_DIAGNOSIS_SCT'
$Tables+='ED_PROCEDURE'
$Tables+='ED_VISIT'

###* Deaths ###
$Tables+='RLDXDTH_AUDIT_TRAIL'
$Tables+='RLDXDTH_OPERATIONAL'
$Tables+='RLDXDTH_RECORD'

$Tables+='DRURF_REPLICA'
$Tables+='DRURF_REPLICA_BOUNDARIES_ALL'
#>

# Hash table to define the properties of the custom object
# Most of these do not change between invocations
# Hardcode the defaults - they can be overridden below
$SqlBulkCopyObject = @{
    'SrcServer'             = $SrcServer;
    'SrcDatabase'           = $SrcDatabase;
    'SrcSchema'             = $SrcSchema;
    'SrcTable'              = $null;  # this is set in the loop
    'TgtServer'             = $TgtServer;
    'TgtDatabase'           = $TgtDatabase;
    'TgtSchema'             = $TgtSchema;
    'TgtTable'              = $null;  # this is set in the loop
    'SqlQuery'              = $null;  # must specify this in the metadata below
    'Clone'                 = $Clone;
    'Rename'                = $Rename;
    'Truncate'              = $Truncate;
    'Quiet'                 = $Quiet;
    'CheckConstraints'      = $CheckConstraints;
    'FireTriggers'          = $FireTriggers;
    'KeepIdentity'          = $KeepIdentity;
    'KeepNulls'             = $KeepNulls;
    'TableLock'             = $TableLock;
    'BatchSize'             = $BatchSize;
    'NotifyAfter'           = $NotifyAfter;
    'CommandTimeout'        = $CommandTimeout;
    'BulkCopyTimeout'       = $BulkCopyTimeout;
}

# Lookup table to contain the custom objects
$ht=@{}

# Create each object and add to the lookup table

# RLDXHOSP_AUDIT_TRAIL
$table='RLDXHOSP_AUDIT_TRAIL'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.SrcDatabase  = 'RLDXHosp_prod'
$obj.SrcTable     = 'RLDX_AUDIT_TRAIL'
$obj.TgtSchema    = 'rldxhosp'
$obj.TgtTable     = $obj.SrcTable

# RLDXHOSP_OPERATIONAL
$table='RLDXHOSP_OPERATIONAL'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.SrcDatabase  = 'RLDXHosp_prod'
$obj.SrcTable     = 'RLDX_OPERATIONAL'
$obj.TgtSchema    = 'rldxhosp'
$obj.TgtTable     = $obj.SrcTable

# RLDXHOSP_RECORD
$table='RLDXHOSP_RECORD'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.SrcDatabase  = 'RLDXHosp_prod'
$obj.SrcTable     = 'RLDX_RECORD'       
$obj.TgtSchema    = 'rldxhosp'
$obj.TgtTable     = $obj.SrcTable

# HIRD_FORMATS
$table='HIRD_FORMATS'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.TgtSchema    = 'meta'

# HIRD_METADATA
$table='HIRD_METADATA'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.TgtSchema    = 'meta'

# DIAGNOSIS
$table='DIAGNOSIS'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# EPISODE
$table='EPISODE'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# EPISODE_ATS
$table='EPISODE_ATS'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# EPISODE_DRG
$table='EPISODE_DRG'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# EPISODE_SRG
$table='EPISODE_SRG'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# FACILITY
$table='FACILITY'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# FACILITY_PEER_GROUP
$table='FACILITY_PEER_GROUP'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# ISC_DIAGNOSIS
$table='ISC_DIAGNOSIS'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# ISC_EPISODE
$table='ISC_EPISODE'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# ISC_EPISODE_DRG
$table='ISC_EPISODE_DRG'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# ISC_PROCEDURE
$table='ISC_PROCEDURE'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# MEDPROC
$table='MEDPROC'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# PATIENT_CONTACT_DETAILS
$table='PATIENT_CONTACT_DETAILS'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# REPLICA_ADDRESS_BOUNDARIES_ALL
$table='REPLICA_ADDRESS_BOUNDARIES_ALL'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# STAY
$table='STAY'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# EPISODE_NWAU
$table='EPISODE_NWAU'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# AP_Identified
$table='AP_Identified'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.CommandTimeout = 5 # no need to wait for the SrcRowCount
$obj.SrcDatabase  = 'APDC_prod'

# RLDXED_AUDIT_TRAIL
$table='RLDXED_AUDIT_TRAIL'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.SrcDatabase  = 'RLDXED_prod'
$obj.SrcTable     = 'RLDX_AUDIT_TRAIL'
$obj.TgtSchema    = 'rldxed'
$obj.TgtTable     = $obj.SrcTable

# RLDXED_OPERATIONAL
$table='RLDXED_OPERATIONAL'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.SrcDatabase  = 'RLDXED_prod'
$obj.SrcTable     = 'RLDX_OPERATIONAL'
$obj.TgtSchema    = 'rldxed'
$obj.TgtTable     = $obj.SrcTable

# RLDXED_RECORD
$table='RLDXED_RECORD'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.SrcDatabase  = 'RLDXED_prod'
$obj.SrcTable     = 'RLDX_RECORD'
$obj.TgtSchema    = 'rldxed'
$obj.TgtTable     = $obj.SrcTable

# ED_DIAGNOSIS
$table='ED_DIAGNOSIS'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# ED_DIAGNOSIS_SCT
$table='ED_DIAGNOSIS_SCT'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# ED_PROCEDURE
$table='ED_PROCEDURE'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# ED_VISIT
$table='ED_VISIT'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)

# RLDXDTH_AUDIT_TRAIL
$table='RLDXDTH_AUDIT_TRAIL'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.SrcDatabase  = 'RLDXDth_prod'
$obj.SrcTable     = 'RLDX_AUDIT_TRAIL'
$obj.TgtSchema    = 'rldxdth'
$obj.TgtTable     = $obj.SrcTable

# RLDXDTH_OPERATIONAL
$table='RLDXDTH_OPERATIONAL'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.SrcDatabase  = 'RLDXDth_prod'
$obj.SrcTable     = 'RLDX_OPERATIONAL'
$obj.TgtSchema    = 'rldxdth'
$obj.TgtTable     = $obj.SrcTable

# RLDXDTH_RECORD
$table='RLDXDTH_RECORD'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.SrcDatabase  = 'RLDXDTH_prod'
$obj.SrcTable     = 'RLDX_RECORD'
$obj.TgtSchema    = 'rldxdth'
$obj.TgtTable     = $obj.SrcTable

# DRURF_Replica
$table='DRURF_Replica'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.SrcDatabase  = 'Deaths_prod'

# 'DRURF_Replica_Boundaries_All'
$table='DRURF_Replica_Boundaries_All'
$obj = New-Object -TypeName PSObject -Property $SqlBulkCopyObject
$ht.Add($table,$obj)
$obj.SrcDatabase  = 'Deaths_prod'

###############################################################################
# MAIN PROCESSING
###############################################################################
# If no tables were specified on the command line then run everything
if ($Tables -eq $null) {
### APDC ###
$Tables+='HIRD_FORMATS'
$Tables+='HIRD_METADATA'

$Tables+='RLDXHOSP_AUDIT_TRAIL'
$Tables+='RLDXHOSP_OPERATIONAL'
$Tables+='RLDXHOSP_RECORD'

$Tables+='DIAGNOSIS'
$Tables+='EPISODE'
$Tables+='EPISODE_ATS'
$Tables+='EPISODE_DRG'
$Tables+='EPISODE_SRG'
$Tables+='FACILITY'
$Tables+='FACILITY_PEER_GROUP'
$Tables+='ISC_DIAGNOSIS'
$Tables+='ISC_EPISODE'
$Tables+='ISC_EPISODE_DRG'
$Tables+='ISC_PROCEDURE'
$Tables+='MEDPROC'
$Tables+='PATIENT_CONTACT_DETAILS'
$Tables+='REPLICA_ADDRESS_BOUNDARIES_ALL'
$Tables+='STAY'

$Tables+='EPISODE_NWAU'

$Tables+='AP_IDENTIFIED'

### EDDC ###
$Tables+='RLDXED_AUDIT_TRAIL'
$Tables+='RLDXED_OPERATIONAL'
$Tables+='RLDXED_RECORD'

$Tables+='ED_DIAGNOSIS'
$Tables+='ED_DIAGNOSIS_SCT'
$Tables+='ED_PROCEDURE'
$Tables+='ED_VISIT'

###* Deaths ###
$Tables+='RLDXDTH_AUDIT_TRAIL'
$Tables+='RLDXDTH_OPERATIONAL'
$Tables+='RLDXDTH_RECORD'

$Tables+='DRURF_REPLICA'
$Tables+='DRURF_REPLICA_BOUNDARIES_ALL'
}

### END OF FILE ###
