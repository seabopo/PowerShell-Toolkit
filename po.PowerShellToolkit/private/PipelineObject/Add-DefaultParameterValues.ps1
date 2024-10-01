Function Add-DefaultParameterValues {
    <#
    .DESCRIPTION
        Adds the default values of the 'DefinedParameters' collection in the callstack's invocation to the
        PipelineObject. Default values will only override null values or empty strings.
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
                        $name         = $_.Name.VariablePath.UserPath.ToString()
                        $defaultValue = $_.DefaultValue
                        if ( $name -ne $i.PipelineObjectParameterName ) {
                            if ( [string]::IsNullOrEmpty($PipelineObject[$name]) ) {
                                if ( -not [string]::IsNullOrEmpty($defaultValue) ) {
                                    $PipelineObject[$name] = $(Invoke-Expression $($defaultValue.Extent.Text))
                                }
                            }
                        }
                    }
            }

            Write-Output $PipelineObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
