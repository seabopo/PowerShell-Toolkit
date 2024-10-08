function Set-AutoGeneratedExceptionMessage {
    <#
    .DESCRIPTION
        If the type of status message is 'exception' and an object of type 'ErrorRecord' is included generate
        a standardized error message.
    #>
    [OutputType([HashTable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [HashTable] $MessageObject )

    process {

        try {

            if ( $MessageObject.Type -eq 'Exception' ) {

                if ( $MessageObject.DebugObject ) {

                    if ( $MessageObject.DebugObject.GetType().Name -eq 'ErrorRecord' ) {

                        $newLine = [System.Environment]::NewLine

                        $errorStatement = $MessageObject.DebugObject.InvocationInfo.Statement ??
                                          $MessageObject.DebugObject.InvocationInfo.Line ??
                                          '<Not available>'

                        $scriptStackTrace = $MessageObject.DebugObject.ScriptStackTrace -split $newLine
                        $scriptStackTrace = $scriptStackTrace -join ($newLine + '        ')
                        $scriptStackTrace = $newLine + '        ' + $scriptStackTrace

                        $exceptionTemplate = $newLine + $( 'Exception Error:'             ) +
                                             $newLine + $('    Function: {0}, line: {1}'  ) +
                                             $newLine + $('    Error Message: {2}'        ) +
                                             $newLine + $('    Code Statement: {3}'       ) +
                                             $newLine + $('    Stack Trace: {4}'          ) +
                                             $newLine + $('    PowerShell: {5} {6} on {7}')

                        $exceptionMessage = $exceptionTemplate -f  $MessageObject.InvocationSource,
                                                                   $MessageObject.DebugObject.InvocationInfo.ScriptLineNumber,
                                                                   $MessageObject.DebugObject.Exception.Message,
                                                                   $($errorStatement.ToString().Trim()),
                                                                   $scriptStackTrace,
                                                                   $PSVersionTable.PSVersion.ToString(),
                                                                   $PSVersionTable.PSEdition,
                                                                   $PSVersionTable.Platform

                        $MessageObject.Message += $exceptionMessage

                        $MessageObject.DebugObject = $null

                    }

                }

            }

            Write-Output $MessageObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
