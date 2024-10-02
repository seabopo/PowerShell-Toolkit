function Set-StatusMessagePrefix {
    <#
    .DESCRIPTION
        Sets the prefix ( TimeStamp | Lable | Indentation ) that will be added to each status message line.
    #>
    [OutputType([HashTable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [HashTable] $MessageObject )

    process {

        try {

            $prefixes = New-Object System.Collections.Generic.List[System.String]

            if ( $MessageObject.TimeStamps ) {
                $prefixes.Add( '{0} ' -f $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss')) )
            }

            if ( $MessageObject.Labels -and ( $MessageObject.Type -in $MessageObject.LabelTypes) ) {
                $prefixes.Add( '{0}: ' -f $MessageObject.Type.ToUpper() )
            }

            if ( $MessageObject.IndentationLevel -gt 0 ) {
                $prefixes.Add( '{0} ' -f ($MessageObject.IndentationString * $MessageObject.IndentationLevel) )
            }

            $prefix = $prefixes -join ''

            if ( -not [string]::IsNullOrEmpty($prefix ) ) {
                $MessageObject.MessagePrefix = $prefix
                $MessageObject.DebugObjectPrefix = $prefix.Substring(0,$prefix.length -1) +
                                                   $MessageObject.IndentationString + ' '
            }

            Write-Output $MessageObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
