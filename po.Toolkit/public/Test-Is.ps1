Function Test-Is {
    <#
    .DESCRIPTION
        Tests if a value exists. This is a replacement for [String]::IsNullOrEmpty(), which doesn't work reliably 
        on objects. The function can be used to test for something (Test-IsSomething) or nothing (Test-IsNothing).
        Using the default function name (Test-Is) will test for something.
    
    .OUTPUTS
        [Boolean]

    .PARAMETER Value
        REQUIRED. Object. Alias: -d. Series data.

    .EXAMPLE
       Test-Is($value)
    
    .EXAMPLE
       Test-IsSomething($value)

    .EXAMPLE
       IsSomething($value)

    .EXAMPLE
       Test-IsNothing($value)

    .EXAMPLE
       IsNothing($value)

    #>
    [Alias('Test-IsSomething','Test-IsNothing','IsSomething','IsNothing')]
    [OutputType([Boolean])]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline,Position = 0)]
        [AllowEmptyString()] [AllowNull()] [AllowEmptyCollection()]
        [Alias('v')] $Value
    )

    process {

        Write-Msg -FunctionCall -IncludeParameters
        
        if ( $null -eq $Value ) {
            $result = $false
        }
        else {
            
            $typeName = $Value.GetType().Name
            Write-Msg -d -il 2 -m $( 'TypeName: {0}' -f $typeName )

            if ( $typeName -eq 'String' -and '' -eq $value ) {
                $result = $false
            }
            elseif ( $typeName -eq 'SwitchParameter' -and $value.IsPresent -eq $true ) {
                $result = $true
            }
            elseif ( $typeName -eq 'SwitchParameter' -and $value.IsPresent -eq $false  ) {
                $result = $false
            }
            else {
                if ( $typeName -eq 'Object[]' ) {
                    try {
                        if ( $value.count -gt 0 ) {
                            Write-Msg -d -il 2 -m $( 'Object Count: {0}' -f $value.count )
                            $result = $true
                        }
                        else {
                            Write-Msg -d -il 2 -m $( 'Object Count: {0}' -f $value.count )
                            $result = $false
                        }
                    }
                    catch {
                        $result = $false
                    }
                }
                else {
                    $result = $true
                }
            }

        }

        if ( $MyInvocation.InvocationName -in @('Test-IsNothing','IsNothing') ) {
            $condition = "IsNothing"
            $result = -not $result
        }
        else {
            $condition = "IsSomething"
        }

        Write-Msg -FunctionResult -m $( 'Condition: {0}' -f $condition ) -o $( 'Result: {0}' -f $result ) #$result

        return $result
    }
}
