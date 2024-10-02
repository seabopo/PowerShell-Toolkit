Function Test-Parameters {
    <#
    .DESCRIPTION
        Performs tests based on the values defined in the PipelineObject's Tests parameter. The Test paramater
        is a hashtable that supports the following values/tests:
         - AnyIsNull
         - AllAreNull
    #>
    [OutputType([Hashtable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [Hashtable] $PipelineObject )

    process {

        try {

          # Get the current invocation object.
            $i = $PipelineObject._Invocation[$PipelineObject._Invocation.ID]

          # Check the entrypoint for the Tests parameter.
            if ( $i.CallStack[0].InvocationInfo.BoundParameters.ContainsKey('Tests') ) {

              # If it exists get the tests.
                $i.Tests.Defined = $true
                $tests = $i.CallStack[0].InvocationInfo.BoundParameters['Tests']

              # Loop through each type of test.
                $tests.keys | ForEach-Object {

                    $testName = $_

                  # Check if the test name is valid.
                    if ( @('AnyIsNull','AllAreNull') -contains $testName ) {

                        $params        = @{}
                        $missingParams = @()

                      # Check each test parameter and make sure they have been added to the PipelineObject.
                        $tests[$testName] | ForEach-Object {
                            $paramName = $_
                            if ( $PipelineObject.ContainsKey($paramName) ) {
                                $params.Add($paramName,$PipelineObject[$paramName])
                            }
                            else { $missingParams += $paramName }
                        }

                      # If all parameters are present, perform the test.
                        if ( $params.count -eq $tests[$testName].count ) {
                            $validationFailed, $failedValues = Test-IsNull -n $testName -v $params -r
                            if ( $validationFailed ) {
                                $i.Tests.Successful = $false
                                $i.Tests.Errors += $( '{0} test failed becasue these values are null: {1}' -f
                                                      $testName, $($failedValues -Join ','))
                            }
                        }
                        else {
                            $i.Tests.Successful = $false
                            $i.Tests.Errors += $(
                                '{0} test failed. PipelineObject is missing the following Parameter(s): {1}' -f
                                $testName, $($missingParams -Join ','))
                        }

                    }
                    else {
                        $i.Tests.Successful = $false
                        $i.Tests.Errors += $(
                            'Tests failed. The following validation test name is not valid: {0}' -f $testName )
                    }

                }

                if ( -not $i.Tests.Successful ) {
                    $PipelineObject.Success = $false
                    $PipelineObject.ResultMessage = $i.Tests.Errors -join ". "
                }

            }

            Write-Output $PipelineObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
