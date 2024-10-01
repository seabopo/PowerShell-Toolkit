Function ConvertTo-MessageString {
    <#
    .DESCRIPTION
        Converts an object to a string suitable for writing to the console.

    .PARAMETER Object
        OPTIONAL. Alias: -o. The object to convert to a string. This can be any type of object
        (int, array, hashtable, etc.).

    .PARAMETER MaxDepth
        OPTIONAL. Integer. Alias: -d. The maximum depth of recursion when converting the Object to a JSON string.
        Default value: 100 (the powreshell max).

    .PARAMETER MultiLinePrefix
        OPTIONAL. String. Alias: -p. A string to prefix each line for an object that requires a multi-line
        object description.

    .PARAMETER MultiLine
        OPTIONAL. Switch. Alias: -r. If the 'MultiLine' switch is used the function will return both the string
        value and a boolean value indicating if the string value is a multi-line string.
    #>
    [OutputType([String])]
    [OutputType([String],[Boolean])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [Alias('o')] $Object,
        [Parameter()] [Int]    [Alias('d')] $MaxDepth = 100,
        [Parameter()] [String] [Alias('p')] $MultiLinePrefix,
        [Parameter()] [Switch] [Alias('r')] $ReturnMultiLineIndicator,
        [Parameter()] [Switch] [Alias('c')] $CompressJSON
    )

    begin {

        $simpleTypes = @( 'String', 'Byte', 'Char',
                          'Int32', 'Int64', 'Double','Single','Decimal',
                          'Boolean', 'DateTime', 'TimeSpan', 'Guid', 'SwitchParameter')

    }

    process {

        try {

            $compress = ( $CompressJSON ) ? @{ Compress = $true } : @{ }

            $typeName = $Object.GetType().Name

            if ( $typeName -in $simpleTypes ) {

                $multiLineReturnValue = $false
                $returnValue = [System.Convert]::ToString($Object)

            }
            elseif ( ( $typeName.EndsWith('[]') -and $typeName -ne 'Object[]' ) -or $typeName -eq 'ArrayList' ) {

                $multiLineReturnValue = $false
                $returnValue = (($Object | ConvertTo-JSON -Depth 0 -Compress) 3> $null )

            }
            else {

                $multiLineReturnValue = $true
                $returnValue = New-Object System.Collections.Generic.List[System.String]
                (($Object | ConvertTo-JSON -Depth $MaxDepth @compress) 3> $null).Split([System.Environment]::NewLine) |
                    ForEach-Object {
                        $returnValue.Add( [System.Environment]::NewLine )
                        $returnValue.Add( $MultiLinePrefix )
                        $returnValue.Add( $_ )
                    }

            }

            Write-Output ( $returnValue -join '' )

            if ( $ReturnMultiLineIndicator ) { Write-Output $multiLineReturnValue }

            return

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
