Function Add-BoundParameterValues {
    <#
    .DESCRIPTION
        Adds the values for the 'BoundParameters' collection (those paramaters which have values passed in) in the
        callstack's invocation to the PipelineObject. BoundParameters will override any previously existing values
        in the PipelineObject.
    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [Hashtable] $PipelineObject )

    process {

        try {

            $i = $PipelineObject._Invocation[$PipelineObject._Invocation.ID]

            $i.BoundParameters.GetEnumerator() |
                ForEach-Object {
                    if ( $PipelineObject.ContainsKey($_.key) ) { $PipelineObject[$_.key] = $_.value }
                }

            Write-Output $PipelineObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
