Function Add-InvocationData {
    <#
    .DESCRIPTION
        Adds the invocation data of the function which called the entrypoint (Initialize-PipelineObject) function.
        The Invocation hashtable is a callstack of each entrypoint call for the PipelineObject so that the data
        can be used for error reporting.
    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [Hashtable] $PipelineObject )

    process {

        try {

          # If the 'Invocation' key does not exist initialize the object.
            if ( -not $PipelineObject.ContainsKey('_Invocation') ) {
                $PipelineObject.Add('_Invocation',@{})
                $PipelineObject._Invocation.Add('ID',$null)
                $PipelineObject.Success = $true
                $PipelineObject.ResultMessage = 'PipelineObject initialized.'
            }
            else {
                $PipelineObject.Success = $true
                $PipelineObject.ResultMessage = 'PipelineObject updated.'
            }

          # Get the callstack for the entrypoint, the entrypoint caller and the caller's predecessor.
            $callStack = Get-PSCallStack | Select-Object -Skip 1 -First 3

          # Get the entrypoint (Initialize-PipelineObject) parameters.
            $entryPointParams = $callStack[0].InvocationInfo.BoundParameters

            $LogInvocation = $($entryPointParams.keys -contains 'LogInvocation') -or
                ([System.Convert]::ToBoolean($env:PS_PIPELINEOBJECT_LOGGING) -eq $true)

            $DontLogParameters = $($entryPointParams.keys -contains 'DontLogParameters') -or
                ([System.Convert]::ToBoolean($env:PS_PIPELINEOBJECT_DONTLOGPARAMS) -eq $true)

            $LogPipelineObjectValues = $($entryPointParams.keys -contains 'LogPipelineObjectValues') -or
                ([System.Convert]::ToBoolean($env:PS_PIPELINEOBJECT_LOGVALUES) -eq $true)

            $IncludeCommonParameters = $($entryPointParams.keys -contains 'IncludeCommonParameters') -or
                ([System.Convert]::ToBoolean($env:PS_PIPELINEOBJECT_INCLUDECOMMONPARAMS) -eq $true)

            $IgnoreParameterNames = $entryPointParams.IgnoreParameterNames ??
                ( $env:PS_STATUSMESSAGE_IGNORE_PARAMS_JSON | ConvertFrom-JSON )

          # Get the caller's invocation information.
            $InvocationInfo = $callStack[1].InvocationInfo

          # Get the caller predecessor's invocation information.
            $predecessorName = $callStack[2].Command ?? ''

          # Build the invocation object.
            $Invocation = @{

                ID                          = '{0}::{1}::{2}' -f $InvocationInfo.InvocationName,
                                                                $predecessorName,
                                                                [Guid]::NewGuid()
                CallName                    = $InvocationInfo.InvocationName
                CommandName                 = $InvocationInfo.MyCommand.Name
                ModuleName                  = $InvocationInfo.MyCommand.ModuleName
                Time                        = $((Get-Date).ToString('yyyy-MM-dd:HH-mm-ss-fff'))
                InvokedFromName             = $predecessorName

                Command                     = $InvocationInfo.MyCommand
                AllParameters               = $InvocationInfo.MyCommand.Parameters
                BoundParameters             = $InvocationInfo.BoundParameters
                DefinedParameters           = $InvocationInfo.MyCommand.ScriptBlock.Ast.Body.ParamBlock.Parameters
                PipelineObjectParameterName = $null

                Tests                       = @{ Defined = $false; Successful = $true; Errors = @() }

                PowerShellVersion           = $PSVersionTable.PSVersion
                PowerShellEdition           = $PSVersionTable.PSEdition
                PowerShellPlatform          = $PSVersionTable.Platform
                PowerShellOS                = $PSVersionTable.OS
                Account                     = $env:USER
                Device                      = $env:COMPUTERNAME

                CallStack                   = $callStack

                LogInvocation               = $LogInvocation
                DontLogParameters           = $DontLogParameters
                LogPipelineObjectValues     = $LogPipelineObjectValues
                IncludeCommonParameters     = $IncludeCommonParameters
                IgnoreParameterNames        = $IgnoreParameterNames

                EntryPointPosition          = $callStack[1].ToString()
                EntryPointLineNumber        = $callStack[1].Position.StartLineNumber
                EntryPointStatement         = $callStack[1].Position.Text

            }

          # Add the invocation object to the PipelineObject's Invocation collection.
            $PipelineObject._Invocation.Add($Invocation.ID,$Invocation)

          # Set the PipelineObject's Invocation ID to the current Invocation ID. This is used by the remaining
          # pipeline functions to add their data and it allows the user to referece the Invocation object in code
          # for error reporting or debugging.
            $PipelineObject._Invocation.ID = $Invocation.ID

          # Write the updated object to the pipeline.
            Write-Output $PipelineObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
