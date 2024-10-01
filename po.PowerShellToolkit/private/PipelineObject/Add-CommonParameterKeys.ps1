Function Add-CommonParameterKeys {
    <#
    .DESCRIPTION
        Adds keys for the 'CommonParameters' in the callstack's invocation to the PipelineObject. Common
        Parameters are the parameters that are available to all cmdlets and advanced functions by enabling
        the 'CmdletBinding' attribute. They include: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction,
        WarningVariable, OutBuffer, OutVariable, PipelineVariable, and InformationAction.
    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [Hashtable] $PipelineObject )

    process {

        try {

            $i = $PipelineObject._Invocation[$PipelineObject._Invocation.ID]

            if ( $i.IncludeCommonParameters ) {
                $functionDefinition = Get-Command $i.Command
                $functionDefinition.Parameters.Keys |
                    ForEach-Object {
                        if ( -not $PipelineObject.ContainsKey($_) ) { $PipelineObject.Add( $_,$null ) }
                    }
            }

            Write-Output $PipelineObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
