Function Remove-RecursiveObjectKey {
    <#
    .DESCRIPTION
        The PipelineObject is a HashTable that is passed through a series of functions via the PowerShell pipeline.

        A PowerShell function can have only one parameter that accepts input via the PipelineObject. This parameter
        is determined by applying the 'ValueFromPipeline' attribute to the parameter.

        Each time the Initialize-PipelineObject funtion is invoked it uses the parameter that is tagged with the
        'ValueFromPipeline' attribute from the calling function as the base object for its operations. If that
        parameter wasn't already intialized as a HashTable it will be by the Initialize-PipelineObject function.
        That parameter is now accounted for in the PipelineObject.

        Once the PipelineObject object is initialized it adds all of the defined and bound parameters to the base
        object. Those parameters include a reference to the PipelineObject. This means that the base object will
        end up with a recursive reference to itself. This can lead to performance problems if it is not cleaned up.

        Objects that have been initialzed by the Initialize-PipelineObject function will have an '_Invocation' key
        and will exist in the BoundParameters collection. If this parameter is not in the bound parameters
        collection then it hasn't been passed via the pipeline and will be an empty HashTable.
    #>
    [OutputType([hashtable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [Hashtable] $PipelineObject )

    process {

        try {

            $i = $PipelineObject._Invocation[$PipelineObject._Invocation.ID]

            $i.DefinedParameters |
                Where-Object { $_.Extent.ToString() -like '*ValueFromPipeline*Hashtable*' } |
                ForEach-Object {
                    $key = $_.Name.VariablePath.UserPath.ToString()
                    if ( $i.BoundParameters.ContainsKey($key) ) {
                        if ( $i.BoundParameters[$key].ContainsKey('_Invocation') ) {
                            $i.PipelineObjectParameterName = $key
                            $PipelineObject.Remove($key)
                        }
                        elseif ( $i.BoundParameters[$key] -eq @{} ) {
                            $PipelineObject.Remove($key)
                        }
                    }
                    else {
                        $i.PipelineObjectParameterName = $key
                        $PipelineObject.Remove($key)
                    }
                }

            Write-Output $PipelineObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
