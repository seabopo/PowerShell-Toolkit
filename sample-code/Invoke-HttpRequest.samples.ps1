#==================================================================================================================
#==================================================================================================================
# Sample Code :: Invoke-ConsoleCommand
#==================================================================================================================
#==================================================================================================================

#==================================================================================================================
# Initialize Test Environment
#==================================================================================================================

Clear-Host

Set-Location  -Path $PSScriptRoot
Push-Location -Path $PSScriptRoot

$ErrorActionPreference = "Stop"

Import-Module '../po.Toolkit/' -Force

$env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $true

#==================================================================================================================
# Run Tests
#==================================================================================================================

Write-Msg -h -ps -bb -m $( ' Invoke-HttpRequest Test Run - SUCCESSFUL Requests Expected' )

  # Initialize the API Key / Bearer Token. api-token.ps1 contains a single line: return '<my api token>'
    $env:CF_API_TOKEN = . '.\api-token.ps1'

  # Tests that should return a successful result.
    Invoke-HttpRequest -u 'https://www.cloudflare.com'
    Invoke-HttpRequest -o 'https' -s 'www.cloudflare.com'
    Invoke-HttpRequest -o 'https' -s 'github.com' -p '/seabopo'
    Invoke-HttpRequest -o 'https' -s 'github.com' -p '/seabopo' -b
    Invoke-HttpRequest -o 'https' -s 'github.com' -p '/seabopo' -b -l
    Invoke-HttpRequest -u 'https://api.cloudflare.com/client/v4/user/tokens/verify' -t $env:CF_API_TOKEN
    Invoke-HttpRequest -u 'https://api.cloudflare.com/client/v4/user/tokens/verify' -t $env:CF_API_TOKEN -j

Write-Msg -h -ps -bb -m $( ' Invoke-HttpRequest Test Run - FAILED Requests with Debug Messages Expected' )

    Invoke-HttpRequest -o 'https' -s 'www.cloudflare.com' -p 'idontexist' -d

Write-Msg -h -ps -bb -m $( ' Invoke-HttpRequest Test Run - FAILED Request with Error Message Expected' )

    Invoke-HttpRequest -o 'https' -s 'www.cloudflare.com' -p 'idontexist'

exit
