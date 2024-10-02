Function Write-InvocationEventLog {
    <#
    .DESCRIPTION
        Logs the invocation information for a function or script if the -log switch is passed.
    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [Hashtable] $PipelineObject )

    process {

        try {

            $i = $PipelineObject._Invocation[$PipelineObject._Invocation.ID]

            if ( $i.LogInvocation ) {

                $msg = New-Object System.Collections.Generic.List[System.String]

                $msg.Add( 'Function Call: ' )
                $msg.Add( $i.CallName )
                if ( $i.CommandName -ne $i.CallName ) { $msg.Add( $(' (alias of {0})' -f $i.CommandName) ) }
                $msg.Add( $(' called from {0}' -f $i.InvokedFromName) )
                $msg.Add( $(' at {0}' -f $i.Time) )

                Write-Msg -p -ps -m $( $msg -join '' )

            }

            Write-Output $PipelineObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
