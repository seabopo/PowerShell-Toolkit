function Invoke-ConsoleCommand {
    <#
    .SYNOPSIS
        Invokes a console command.

    .DESCRIPTION
        Invokes a console command which is passed as a string array or commands, values and parameters.

    .OUTPUTS
        A PSCustomObject with the following properties:
            - Success: Boolean
            - Result: String
            - Errors: String
            - Command: String
            - StartTime: DateTime
            - EndTime: DateTime
            - Duration: Int

    .PARAMETER Command
        REQUIRED. Array of String. Alias: -c. A string array representing the console command to be invoked.

    .PARAMETER Retries
        OPTIONAL. Int. Alias: -r. The number of times to retry the command if it fails. Default: 3

    .PARAMETER RetryDelay
        OPTIONAL. Int. Alias: -r. The amount of time to wait between retries in seconds. Default: 5

    .PARAMETER FailureIsNotAnError
        OPTIONAL. Switch. Alias: -f. Do not consider a command failure an error.

    .PARAMETER Silent
        OPTIONAL. Switch. Alias: -s. Do not log. Overrides the logging preferences set at the environment level.

    .EXAMPLE
        Invoke-ConsoleCommand -Command @('c:\windows\notepad.exe','C:\file.txt') -r 3 -d 10
    #>
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    [Alias('Invoke-Cmd')]
    param (
        [Parameter()] [Alias('c')] [String[]] $Command,
        [Parameter()] [Alias('r')] [Int]      $Retries = 5,
        [Parameter()] [Alias('d')] [Int]      $RetryDelay = 15,
        [Parameter()] [Alias('f')] [Switch]   $FailureIsNotAnError,
        [Parameter()] [Alias('s')] [Switch]   $Silent
    )

    process {

        try {

            $r = @{
                command   = $Command -join ' '
                success   = $true
                value     = $null
                message   = $null
                startTime = $null
                duration  = $null
            }

            $commandMsg = $( 'Executing command: {0}' -f $r.Command )

            do {

                try {

                    $r.StartTime = Get-Date
                    $commandErrors = $( $r.value = Invoke-Expression -Command $r.command ) 2>&1
                    if ( $commandErrors ) {
                        if ( $commandErrors -is [System.Management.Automation.ErrorRecord] ) {
                            if ( $commandErrors.Exception.Message.StartsWith( 'WARNING: ' ) ) {
                                $r.message = $commandErrors.Exception.Message
                                if ( -not $Silent ) {
                                    Write-Msg -w -il 1 -m $commandMsg
                                    Write-Msg -w -il 2 -m $( $commandErrors.Exception.Message )
                                }
                            }
                            elseif ( $FailureIsNotAnError ) {
                                $r.message = $commandErrors.Exception.Message
                                if ( -not $Silent ) {
                                    Write-Msg -d -il 1 -m $commandMsg
                                    Write-Msg -d -il 2 -m $( $commandErrors.Exception.Message )
                                }
                            }
                            else { throw $commandErrors.Exception }
                        }
                        else { throw $commandErrors }
                    }
                    else {
                        if ( -not $Silent ) { Write-Msg -d -il 1 -m $commandMsg }
                    }

                    $r.duration = [Math]::Round((New-TimeSpan -Start $r.startTime -End (Get-Date)).TotalSeconds,0)
                    Write-Msg -d -il 2 -m $( 'Command completed in {0} seconds.' -f $r.duration )

                }
                catch {

                    $r.success = $false
                    $r.duration = [Math]::Round((New-TimeSpan -Start $r.startTime -End (Get-Date)).TotalSeconds,0)
                    $r.message = $_.Exception.Message

                    if ( -not $Silent ) {
                        Write-Msg -w -il 1 -m $commandMsg
                        Write-Msg -w -il 2 -m $( 'Command failed after {0} seconds.' -f $r.duration )
                        Write-Msg -w -il 2 -m $( $r.message )
                    }

                    if ( $Retries -gt 0 ) {
                        if ( -not $Silent ) {
                            Write-Msg -w -il 2 -m $( 'Retrying in {0} seconds ...' -f $RetryDelay )
                            Start-Sleep -Seconds $RetryDelay
                        }
                    }

                }

                $Retries--

            } until ( $r.success -or $Retries -le 0 )

            if ( -not $Silent -and $FailureIsNotAnError -and -not $r.success ) {
                Write-Msg -w -il 2 -m 'Command failed after all retries.'
            }
            elseif ( -not $Silent -and -not $r.success ) {
                Write-Msg -e -il 2 -m 'Command failed after all retries.'
            }

        }

        catch {

            Write-Msg -x -o $_
            $r.value = $_.Exception.Message
            $r.Success = $false

        }

        return $r

    }

}
