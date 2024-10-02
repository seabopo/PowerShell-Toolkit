Function Initialize-PipelineObject {
    <#
    .SYNOPSIS
        Creates a Hashtable (or appends to a passed Hashtable) a set of key/value pairs based on the parameters
        and invocation data of the calling function.

    .DESCRIPTION
        Creates a Hashtable (or appends to a passed Hashtable) a set of key/value pairs based on the parameters
        and invocation data of the calling function.

    .OUTPUTS
        A hashtable which contains:
          - A key/value pair for every defined paramater, populated with either the bound (passed) values, the
            default values or null.
          - A key/value pair for every common paramater if:
              - The [CmdletBinding()] attribute is defined in the funciton.
              - The IncludeCommonParameters switch is passed.
          - An 'invocation' key (hashtable) containing information realted to the function call, including user,
            device, IP address, date/time, command, function alias, callstack and additional related items.

    .PARAMETER PipelineObject
        OPTIONAL. Hashtable. A hashtable of values that will be used as the base object to which all PipelineObject
        functions will append the invocation and parameter data.

    .PARAMETER Tests
        OPTIONAL. Hashtable. Alias: -t. Determines if the commom powershell paramaters should be included
        in the pipeline object. This also requires that [CmdletBinding()] is defined in teh calling function.

    .PARAMETER ReturnInvocationID
        OPTIONAL. Switch. Alias: -r, -rii. Includes the invocation ID as part of the return values. All calls to
        the entrypoint function will have their invocation data stored in the PipelineObject.Invocation hashtable.
        The invocation ID is the key to each call's invocation data. The most recent invocation ID is stored in
        $PipelineObject.Invocation.ID

        Example:

            $PipelineObject = Initialize-PipelineObject
            $invocation = $PipelineObject.Invocation[$PipelineObject.Invocation.ID]

            or

            $PipelineObject, $InvocationID = Initialize-PipelineObject -ReturnInvocationID

    .PARAMETER LogInvocation
        OPTIONAL. Switch. Alias: -l, -log. Logs the function call and any parameters passed to the function.
        This value can be set using an environment variable.
            Example: $env:PS_PIPELINEOBJECT_LOGGING = $true

    .PARAMETER DontLogParameters
        OPTIONAL. Switch. Alias: -p, -dlp. Skips the logging of all parameters passed to the function so only the
        function call is logged.
        This value can be set using an environment variable.
            Example: $env:PS_PIPELINEOBJECT_DONTLOGPARAMS = $true

    .PARAMETER LogPipelineObjectValues
        OPTIONAL. Switch. Alias: -o, -lpo. Include the PipeLineObject in the parameter logs. This object is
        skipped by default.
        This value can be set using an environment variable.
            Example: $env:PS_PIPELINEOBJECT_LOGVALUES = $true

    .PARAMETER IgnoreParameterNames
        OPTIONAL. String Array. Alias: -g, -ipn. Skips logging any parameters whose name is in the defined array.
        Default value: @('Invocation'), which is PipelineObject's own property.
        This value can be set using an environment variable.
            Example: $env:PS_STATUSMESSAGE_IGNORE_PARAM_NAMES = '["Invocation","Token"]'
        NOTE: Environment variable values are always treated as strings and do not support arrays or other complex
              object types, so the value must be stored in JSON array format: '["Invocation","Token"]'

    .PARAMETER IncludeCommonParameters
        OPTIONAL. Switch. Alias: -i, -icp. Determines if the commom powershell paramaters should be included
        in the pipeline object. This also requires that [CmdletBinding()] is defined in teh calling function.
        This value can be set using an environment variable.
            Example: $env:PS_PIPELINEOBJECT_INCLUDECOMMONPARAMS = $true

    .EXAMPLE
        The following code:

            function Test-Function {
                [CmdletBinding()]
                param (
                    [Parameter()] [String] $StringParam = 'Default text string',
                    [Parameter()] [Int]    $IntParam    = 1234567890
                )
                process {
                    $PO = Initialize-PipelineObject
                }
            }

        ... would result in the following object being returned by the Initialize-PipelineObject function:

            $PO = @{
                StringParam = <passed value> or 'Default text string',
                IntParam    = <passed value> or 1234567890,
                Invocation  = @{
                    User        = 'DOMAIN\username',
                    Device      = 'COMPUTERNAME',
                    IPAddress   = '123.456.789.012',
                    ...
                }
            }

    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    [OutputType([hashtable],[String])]
    param (
        [Parameter()][Alias('t')]       [Hashtable] $Tests,
        [Parameter()][Alias('r','rii')] [Switch]    $ReturnInvocationID,
        [Parameter()][Alias('l','log')] [Switch]    $LogInvocation,
        [Parameter()][Alias('p','dlp')] [Switch]    $DontLogParameters,
        [Parameter()][Alias('o','lpo')] [Switch]    $LogPipelineObjectValues,
        [Parameter()][Alias('i','icp')] [Switch]    $IncludeCommonParameters,
        [Parameter()][Alias('g','ipn')] [String[]]  $IgnoreParameterNames,

        [Parameter(ValueFromPipeline)] [ValidateNotNull()] [Hashtable] $PipelineObject = @{}
    )

    process {

        try {

            $PipelineObject |
                Add-InvocationData |
                Add-DefinedParameterKeys |
                Add-CommonParameterKeys  |
                Remove-RecursiveObjectKey |
                Add-BoundParameterValues |
                Add-DefaultParameterValues |
                Test-Parameters |
                Remove-RecursiveInvocationObjects |
                Write-InvocationEventLog |
                Write-InvocationEventLogParameters |
                Exit-Processing |
                Out-Null

            Write-Output $PipelineObject

            if ( $ReturnInvocationID ) { Write-Output $PipelineObject._Invocation.ID }

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}


