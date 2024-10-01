#==================================================================================================================
#==================================================================================================================
# Sample Code :: Initialize-PipelineObject
#==================================================================================================================
#==================================================================================================================

#==================================================================================================================
# Initialize Test Environment
#==================================================================================================================

Clear-Host

Set-Location  -Path $PSScriptRoot
Push-Location -Path $PSScriptRoot

$ErrorActionPreference = "Stop"

Import-Module '../po.PowerShellToolkit/' -Force

$env:PS_PIPELINEOBJECT_LOGGING             = $false
$env:PS_PIPELINEOBJECT_DONTLOGPARAMS       = $false
$env:PS_PIPELINEOBJECT_LOGVALUES           = $false
$env:PS_PIPELINEOBJECT_INCLUDECOMMONPARAMS = $false

$env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES  = $true

#==================================================================================================================
# Testing Functions (Initialize-PipelineObject is meant to interrogate functions.)
#==================================================================================================================

function Test-PipelineObjectStep1 {
    [CmdletBinding()]
    [Alias('Test-PipelineObjectStep1x')]
    param (
        [Parameter()] [String]         $StringParam         = 'Default text string 1',
        [Parameter()] [String[]]       $StringArrayParam    = @('string1a','string1b','string1c'),
        [Parameter()] [Char]           $CharParam           = 'a',
        [Parameter()] [Byte]           $ByteParam           = 155,
        [Parameter()] [Int]            $IntParam            = 1234567890,
        [Parameter()] [Int[]]          $IntArrayParam       = @(1,2,3,4,5,6,7,8,9,0),
        [Parameter()] [Long]           $LongParam           = 1234567890,
        [Parameter()] [Float]          $FloatParam          = 1234567890.1234567890,
        [Parameter()] [Double]         $DoubleParam         = 1234567890.1234567890,
        [Parameter()] [Decimal]        $DecimalParam        = 1234567890.1234567890,
        [Parameter()] [DateTime]       $DateTimeParam       = (Get-Date),
        [Parameter()] [Switch]         $SwitchParam,
        [parameter()] [Hashtable]      $HashtableParam      = @{ Key1='Value1a'; Key2='Value1b' },
        [parameter()] [PSCustomObject] $CustomObjectParam   = [PSCustomObject]@{ Key1='Value1a'; Key2='Value1b' },
        [parameter()] [PSCustomObject] $OrderedObjectParam  = [Ordered]@{ Key1='Value1a'; Key2='Value1b' },

        [Parameter(DontShow,ValueFromPipeline,ParameterSetName='P')] [Hashtable] $PO = @{}
    )

    process {

        try {

            $PO.CustomEntry1 = $null
            $PO.CustomEntry2 = 'Custom text string XXX'
            $PO.CustomEntry3 = @{ value1='value1111'; value2='value2222' }

            $PO,$ID = $PO | Initialize-PipelineObject -l -r -t @{ AllAreNull = @('StringParam','IntParam') }

            Write-Msg -s -ps -ds -m ( 'Invocation ID: {0}' -f $ID )

            if ($PO._Invocation[$ID].Tests.Successful) {
                $PO | Test-PipelineObjectStep2 | Out-Null
                $PO | Test-PipelineObjectStep3 -test $PO | Out-Null
            }

            $PO

        }

        catch {
            write-host $_.Exception.Message    -ForegroundColor Red
            write-host $_.ErrorDetails.Message -ForegroundColor Red
        }

    }
}

function Test-PipelineObjectStep2 {
    [CmdletBinding()]
    [Alias('Test-PipelineObjectStep2x')]
    param (
        [Parameter()] [String]         $StringParam2         = 'Default text string 2',
        [Parameter()] [String[]]       $StringArrayParam2    = @('string2a','string2b'),
        [Parameter()] [Char]           $CharParam2           = 'b',
        [Parameter()] [Byte]           $ByteParam2           = 255,
        [Parameter()] [Int]            $IntParam2            = 234567890,
        [Parameter()] [Int[]]          $IntArrayParam2       = @(2,3,4,5,6,7,8,9,0),
        [Parameter()] [Long]           $LongParam2           = 234567890,
        [Parameter()] [Float]          $FloatParam2          = 234567890.234567890,
        [Parameter()] [Double]         $DoubleParam2         = 234567890.234567890,
        [Parameter()] [Decimal]        $DecimalParam2        = 234567890.234567890,
        [Parameter()] [DateTime]       $DateTimeParam2       = (Get-Date),
        [Parameter()] [Switch]         $SwitchParam2,
        [parameter()] [Hashtable]      $HashtableParam2      = @{ Key1='Value2a'; Key2='Value2b' },
        [parameter()] [PSCustomObject] $CustomObjectParam2   = [PSCustomObject]@{ Key1='Value2a'; Key2='Value2b' },
        [parameter()] [PSCustomObject] $OrderedObjectParam2  = [Ordered]@{ Key1='Value2a'; Key2='Value2b' },

        [Parameter(DontShow,ValueFromPipeline,ParameterSetName='P')] [Hashtable] $PO
    )

    process {
        $PO | Initialize-PipelineObject -log
        $PO
    }
}

function Test-PipelineObjectStep3 {

    [CmdletBinding()]
    [Alias('Test-PipelineObjectStep3x')]
    param (
        [Parameter()] [String]    $StringParamX = 'Default text string X',
        [Parameter()] [String]    $StringParamY = 'Default text string Y',
        [Parameter()] [Hashtable] $Test,

        [Parameter(DontShow,ValueFromPipeline,ParameterSetName='P')] [Hashtable] $PO
    )

    process {

        $PO,$id = Initialize-PipelineObject -l -o -r -t @{ AnyIsNull = @('StringParamX','IntentionallyBadTestParam') }

    }
}

#==================================================================================================================
# Run Tests
#==================================================================================================================

$testparams = @{
    StringParam = 'Custom text string 0'
}

Write-Msg -Type 'Header' -Message 'PipelineObject Examples' -DoubleBanner -ColorBanners

Test-PipelineObjectStep1x @testparams
