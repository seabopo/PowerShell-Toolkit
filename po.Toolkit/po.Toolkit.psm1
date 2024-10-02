#==================================================================================================================
#==================================================================================================================
# po.PowerShellToolkit
#==================================================================================================================
#==================================================================================================================

#==================================================================================================================
# Initializations
#==================================================================================================================

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$ErrorActionPreference = "Stop"

Set-Variable -Scope 'Local' -Name "PS_MODULE_ROOT" -Value $PSScriptRoot
Set-Variable -Scope 'Local' -Name "PS_MODULE_NAME" -Value $($PSScriptRoot | Split-Path -Leaf)

#==================================================================================================================
# StatusMessage Environment Variables
#==================================================================================================================

# REQUIRED Environment Variables
# The Following set of environment variables are REQUIRED for the module to function.

# Initialize the user-definable "verbose" mesage types. Select from the following list:
# Header, Process, Action, Information, Debug, Success, Warning, Failure, Error and Exception.
if ($null -eq $env:PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES ) {
    $env:PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES = '["Debug","Information"]'
}

# Initialze prefix labes. The default behavior is to not show labels, but to use colors instead.
if ($null -eq $env:PS_STATUSMESSAGE_LABEL_MESSAGE_TYPES ) {
    $env:PS_STATUSMESSAGE_LABEL_MESSAGE_TYPES = '["Debug","Success","Warning","Failure","Error","Exception"]'
}

# Initialize the paramaters to ignore when logging. The "_Invocation" parameter should always be ignored as it
# is used in the PipelineObject.
if ($null -eq $env:PS_STATUSMESSAGE_IGNORE_PARAMS_JSON ) {
    $env:PS_STATUSMESSAGE_IGNORE_PARAMS_JSON  = '["_Invocation"]'
}

# Initialize the REQUIRED message formatting preferences:
if ($null -eq $env:PS_STATUSMESSAGE_INDENTATION_STRING ) { $env:PS_STATUSMESSAGE_INDENTATION_STRING  = '...' }
if ($null -eq $env:PS_STATUSMESSAGE_BANNER_STRING      ) { $env:PS_STATUSMESSAGE_BANNER_STRING       = '-'   }
if ($null -eq $env:PS_STATUSMESSAGE_BANNER_LENGTH      ) { $env:PS_STATUSMESSAGE_BANNER_LENGTH       = 80    }
if ($null -eq $env:PS_STATUSMESSAGE_MAX_RECURSION_DEPTH) { $env:PS_STATUSMESSAGE_MAX_RECURSION_DEPTH = 10    }

# OPTIONAL Environment Variables
# The following set of environment variables are OPTIONAL and can be set to customize the behavior of the module.

# $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES    = $false
# $env:PS_STATUSMESSAGE_LABELS                   = $false
# $env:PS_STATUSMESSAGE_TIMESTAMPS               = $false
# $env:PS_STATUSMESSAGE_COLOR_BANNERS            = $false
# $env:PS_STATUSMESSAGE_COLOR_DEBUG_OBJECTS      = $false
# $env:PS_STATUSMESSAGE_USE_ALL_OUTPUT_STREAMS   = $false


#==================================================================================================================
# PipelineObject Environment Variables
#==================================================================================================================

# The values below are set to the PipelineObject default values.

# By default the PipelineObject will not log any function calls or input parameters.
# $env:PS_PIPELINEOBJECT_LOGGING = $false

# If PipelineObject logging is enabled the PipelineObject will log all parameters names passed to a function, but
# will not log their values by default.
# $env:PS_PIPELINEOBJECT_DONTLOGPARAMS = $false
# $env:PS_PIPELINEOBJECT_LOGVALUES     = $false

# If PipelineObject logging is enabled the PipelineObject will NOT log the PowerShell common parameters by default.
# $env:PS_PIPELINEOBJECT_INCLUDECOMMONPARAMS = $false

#==================================================================================================================
# Load Functions and Export Public Functions and Aliases
#==================================================================================================================

# Define the root folder source lists for public and private functions
$publicFunctionsRootFolders  = @('Public')
$privateFunctionsRootFolders = @('Private')

# Load all public functions
$publicFunctionsRootFolders | ForEach-Object {
    Get-ChildItem -Path "$PS_MODULE_ROOT\$_\*.ps1" -Recurse | ForEach-Object { . $($_.FullName) }
}

# Export all the public functions and aliases (enable for testing only)
# Export-ModuleMember -Function * -Alias *

# Load all private functions
$privateFunctionsRootFolders | ForEach-Object {
    Get-ChildItem -Path "$PS_MODULE_ROOT\$_\*.ps1" -Recurse | ForEach-Object { . $($_.FullName) }
}
