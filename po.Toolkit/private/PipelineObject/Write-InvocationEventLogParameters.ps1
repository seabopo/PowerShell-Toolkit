Function Write-InvocationEventLogParameters {
    <#
    .DESCRIPTION
        Logs the invocation information for a function or script if the -log switch is passed.
        ConvertTo-JSON throws a warning whenever the JSON is truncated so use '3> $null' to kill the warning.
    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [Hashtable] $PipelineObject )

    process {

        try {

            $i = $PipelineObject._Invocation[$PipelineObject._Invocation.ID]

            if ( $i.LogInvocation -and $i.DontLogParameters -eq $false ) {

                $indent = $env:PS_STATUSMESSAGE_INDENTATION_STRING

                $msg = New-Object System.Collections.Generic.List[System.String]

                $msg.Add( $('{0} Bound Parameters: ' -f $indent) )

                if ( $i.BoundParameters.Count -eq 0 ) {
                    $msg.Add( $('No Parameters passed.' ) )
                }
                else {
                    $i.BoundParameters.GetEnumerator() |
                        Where-Object { $_.key -notin $i.IgnoreParameterNames } |
                        Sort-Object |
                        ForEach-Object {

                            $msg.Add( [System.Environment]::NewLine )
                            $msg.Add( $('{0} {1}: ' -f ($indent * 2), $_.key) )

                            if ( $_.key -eq $i.PipelineObjectParameterName -and -not $i.LogPipelineObjectValues) {
                                $msg.Add( $('[{0}]' -f $_.Value.GetType().Name) )
                            }
                            else {
                                if ( $null -eq $_.Value ) {
                                    $value, $multiLine = ConvertTo-MessageString -o 'null' -p ($indent * 3) -r -d 0
                                }
                                else {
                                    $value, $multiLine = ConvertTo-MessageString -o $_.Value -p ($indent * 3) -r -d 0
                                }
                                if ( $multiLine ) {
                                    $msg.Add( $('[{0}]' -f $_.Value.GetType().Name) )
                                    $msg.Add( $value )
                                }
                                else {
                                    $msg.Add( $value )
                                }
                            }
                        }
                }

                Write-Msg -d -m $($msg -join '')

            }

            Write-Output $PipelineObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
