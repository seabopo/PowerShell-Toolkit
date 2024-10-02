Function Add-DefinedParameterKeys {
    <#
    .DESCRIPTION
        Adds keys for the 'DefinedParameters' in the callstack's invocation to the PipelineObject. Defined
        Parameters are the parameters that are explicitly defined in the function's parameter block.
    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [Hashtable] $PipelineObject )

    process {

        try {

            $i = $PipelineObject._Invocation[$PipelineObject._Invocation.ID]

            if ( $i.DefinedParameters ) {
                $i.DefinedParameters.GetEnumerator() |
                    ForEach-Object {
                        $key = $_.Name.VariablePath.UserPath.ToString()
                        if ( -not $PipelineObject.ContainsKey($key) ) { $PipelineObject.Add( $key,$null ) }
                    }
            }

            Write-Output $PipelineObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
