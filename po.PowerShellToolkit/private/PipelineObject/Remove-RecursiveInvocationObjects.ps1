Function Remove-RecursiveInvocationObjects {
    <#
    .DESCRIPTION
        Remove the larger / recursive invocation objects (callstack, etc...) from the PipelineObject since they
        are no longer required at this point in the workflow to prevent memory and performance issues.
    #>
    [OutputType([hashtable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [Hashtable] $PipelineObject )

    process {

        try {

            $i = $PipelineObject._Invocation[$PipelineObject._Invocation.ID]

          # Lots of Recursion
            $i.Remove('CallStack')

          # Contains an AST block with plays havoc with ConvertTo-JSON.
            $i.Remove('DefinedParameters')

            Write-Output $PipelineObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
