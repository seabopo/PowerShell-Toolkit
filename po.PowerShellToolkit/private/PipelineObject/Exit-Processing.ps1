Function Exit-Processing {
    <#
    .DESCRIPTION
        Checks for PipelineObject initialization errors and throws an exception if any are found.
    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [Hashtable] $PipelineObject )

    process {

        try {

          # Setup the error message template.
            $errorMessage = [System.Environment]::NewLine + $( 'PipeLineObject Initialization Error:') +
                            [System.Environment]::NewLine + $('    Function: {0}, line: {1}'         ) +
                            [System.Environment]::NewLine + $('    Error Message: {2}'               ) +
                            [System.Environment]::NewLine + $('    Code Statement: {3}'              ) +
                            [System.Environment]::NewLine + $('    Stack Trace: {4}'                 ) +
                            [System.Environment]::NewLine + $('    PowerShell: {5} {6} on {7}'       )

          # Get the current invocation object.
            $i = $PipelineObject._Invocation[$PipelineObject._Invocation.ID]

          # Check parameter testing errors.
            if ( $i.Tests.Successful ) {
                Write-Output $PipelineObject
            }
            else {
                $PipelineObject.ResultMessage = $errorMessage -f  $i.CallName,
                                                                  $i.EntryPointLineNumber,
                                                                  $( 'PipelineObject Initialization Error: {0}' -f
                                                                      ($i.Tests.Errors -join ". ") ),
                                                                  $i.EntryPointStatement,
                                                                  $i.EntryPointPosition,
                                                                  $PSVersionTable.PSVersion.ToString(),
                                                                  $PSVersionTable.PSEdition,
                                                                  $PSVersionTable.Platform
                Throw 'psToolkit: PipelineObject Initialization Error.'
            }
        }

        catch {
            $PipelineObject.Success = $false
            Write-Msg -e -m $PipelineObject.ResultMessage
        }

    }
}
