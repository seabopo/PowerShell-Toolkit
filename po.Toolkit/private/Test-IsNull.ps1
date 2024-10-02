Function Test-IsNull {
    <#
    .DESCRIPTION
        Tests if the values in the passed hashtable are null.
    #>
    [OutputType([Boolean],[String[]])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)] [ValidateSet('AnyIsNull','AllAreNull')] [Alias('n')] [String]    $TestName,
        [Parameter(Mandatory)] [ValidateNotNullOrEmpty()]              [Alias('v')] [Hashtable] $TestValues,
        [Parameter()]                                                  [Alias('r')] [Switch]    $ReturnFailedKeys
    )

    process {

        try {

            $failedkeys = @( $TestValues.Keys | Where-Object { [String]::IsNullOrEmpty($TestValues[$_]) } )

            $pass = switch ( $TestName ) {
                        'AnyIsNull'  { if ( $failedkeys.count -gt 0 )                 { $true } else { $false } }
                        'AllAreNull' { if ( $TestValues.count -eq $failedkeys.count ) { $true } else { $false } }
                    }

            if ( $ReturnFailedKeys ) {
                return $pass, $failedkeys
            }
            else {
                return $pass
            }

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
