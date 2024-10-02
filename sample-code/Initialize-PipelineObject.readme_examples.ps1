#==================================================================================================================
#==================================================================================================================
# Example Code :: Initialize-PipelineObject
#==================================================================================================================
#==================================================================================================================

#==================================================================================================================
# Initialize Test Environment
#==================================================================================================================

Clear-Host

Set-Location  -Path $PSScriptRoot
Push-Location -Path $PSScriptRoot

Import-Module '../po.Toolkit/' -Force

$env:PS_PIPELINEOBJECT_LOGGING             = $false
$env:PS_PIPELINEOBJECT_DONTLOGPARAMS       = $false
$env:PS_PIPELINEOBJECT_LOGVALUES           = $false
$env:PS_PIPELINEOBJECT_INCLUDECOMMONPARAMS = $false

#==================================================================================================================
# Example 1
#==================================================================================================================

Write-Msg -Process -Banner -PreSpace -Message 'Example 1 - Using the PipelineObject in a single function'

function Test-PipelineObject1 {

    param (
        [Parameter()] [String]   $StringParam       = 'Default text string 1',
        [Parameter()] [String]   $StringParam2      = 'Default text string 2',
        [Parameter()] [String]   $StringParam3,
        [Parameter()] [String[]] $StringArrayParam  = @('string1a','string1b'),
        [Parameter()] [Char]     $CharParam         = 'a',
        [Parameter()] [Byte]     $ByteParam         = 155,
        [Parameter()] [Int]      $IntParam          = 1234567890
    )

  # Create a new PipelineObject
    $PipelineObject = Initialize-PipelineObject

  # Add more data to it
    $PipelineObject.CharParam = 'b'
    $PipelineObject.StringParam4 = 'Default text string 4'

  # Write out the value of the pipeline object
    Write-Output $PipelineObject

}

$result = Test-PipelineObject1 -StringParam 'Custom String'
$result.Remove('_Invocation')
$result.Remove('Success')
$result.Remove('ResultMessage')
$result


#==================================================================================================================
# Example 2
#==================================================================================================================

Write-Msg -Process -Banner -PreSpace -Message ' Example 2 - Using the PipelineObject in multiple functions'

function Test-PipelineObject2 {

  param (
      [Parameter()] [String]   $StringParam       = 'Default text string 1',
      [Parameter()] [String]   $StringParam2      = 'Default text string 2',
      [Parameter()] [String]   $StringParam3,
      [Parameter()] [String[]] $StringArrayParam  = @('string1a','string1b'),
      [Parameter()] [Char]     $CharParam         = 'a',
      [Parameter()] [Byte]     $ByteParam         = 155,
      [Parameter()] [Int]      $IntParam          = 1234567890
  )

# Create a new PipelineObject
  $PipelineObject = Initialize-PipelineObject

# Add more data to it
  $PipelineObject.CharParam = 'b'
  $PipelineObject.StringParam4 = 'Default text string 4'

# Pass it to an additional function to add more data
  $PipelineObject | Add-MoreData2

}

function Add-MoreData2 {

  param (
    [Parameter()] [String] $StringParam4,
    [Parameter()] [String] $StringParam5,

    [Parameter(ValueFromPipeline)] [Hashtable] $PipelineObject = @{}
  )

# Append to pipeline object, instead of re-initializing it ( $PipelineObject = Initialize-PipelineObject ).
  $PipelineObject | Initialize-PipelineObject | Out-Null

# Append more data to it.
  $PipelineObject.StringParam6 = 'Default text string 6'

# Write it out to the pipleline for use by the calling cfunction.
  Write-Output $PipelineObject
}

$result = Test-PipelineObject2 -StringParam 'Custom String'
$result.Remove('_Invocation')
$result.Remove('Success')
$result.Remove('ResultMessage')
$result


#==================================================================================================================
# Example 3 - Logging
#==================================================================================================================

Write-Msg -Process -Banner -PreSpace -Message ' Example 3 - Logging'

$env:PS_PIPELINEOBJECT_LOGGING             = $true
$env:PS_PIPELINEOBJECT_DONTLOGPARAMS       = $false
$env:PS_PIPELINEOBJECT_LOGVALUES           = $true
$env:PS_PIPELINEOBJECT_INCLUDECOMMONPARAMS = $false

function Test-PipelineObject3 {

  param (
      [Parameter()] [String]   $StringParam       = 'Default text string 1',
      [Parameter()] [String]   $StringParam2      = 'Default text string 2',
      [Parameter()] [String]   $StringParam3,
      [Parameter()] [String[]] $StringArrayParam  = @('string1a','string1b'),
      [Parameter()] [Char]     $CharParam         = 'a',
      [Parameter()] [Byte]     $ByteParam         = 155,
      [Parameter()] [Int]      $IntParam          = 1234567890
  )

# Create a new PipelineObject
  $PipelineObject = Initialize-PipelineObject

# Add more data to it
  $PipelineObject.CharParam = 'b'
  $PipelineObject.StringParam4 = 'Default text string 4'

# Write out the value of the pipeline object
  Write-Msg -w -ps -m 'Value before calling Add-MoreData3' -Object $PipelineObject -MaxRecursionDepth 1

# Pass it to an additional function to add more data
  $PipelineObject | Add-MoreData3

}

function Add-MoreData3 {

  param (
    [Parameter()] [String] $StringParam4,
    [Parameter()] [String] $StringParam5,

    [Parameter(ValueFromPipeline)] [Hashtable] $PipelineObject = @{}
  )

# Append to pipeline object, instead of re-initializing it ( $PipelineObject = Initialize-PipelineObject ).
  $PipelineObject | Initialize-PipelineObject | Out-Null

# Append more data to it.
  $PipelineObject.StringParam6 = 'Default text string 6'

# Write it out to the pipleline for use by the calling cfunction.
  Write-Output $PipelineObject
}

$env:PS_PIPELINEOBJECT_LOGGING   = $true
$env:PS_PIPELINEOBJECT_LOGVALUES = $true

$result = Test-PipelineObject3 -StringParam 'Custom String'
$result.Remove('_Invocation')
$result.Remove('Success')
$result.Remove('ResultMessage')
Write-Msg -a -ps -m 'Results:'
$result


#==================================================================================================================
# Example 4 - Logging and Debugging Only
#==================================================================================================================

Write-Msg -Process -Banner -PreSpace -Message ' Example 4 - Logging and Debugging Only'

function Test-PipelineObject4 {

  param (
      [Parameter()] [String]   $StringParam       = 'Default text string 1',
      [Parameter()] [String]   $StringParam2      = 'Default text string 2',
      [Parameter()] [String]   $StringParam3,
      [Parameter()] [String[]] $StringArrayParam  = @('string1a','string1b'),
      [Parameter()] [Char]     $CharParam         = 'a',
      [Parameter()] [Byte]     $ByteParam         = 155,
      [Parameter()] [Int]      $IntParam          = 1234567890
  )

# Create a new PipelineObject
  $PipelineObject, $InvocationID = Initialize-PipelineObject -ReturnInvocationID

  try {
      Throw 'This is a test exception'
  }
  catch {

    Write-Msg -Exception -Object $_

    Write-Msg -e -ps -m 'Function Invocation Data ' -o $PipelineObject._Invocation[$InvocationID] -rd 0

  }

}

$result = Test-PipelineObject4 -StringParam 'Custom String'

exit
