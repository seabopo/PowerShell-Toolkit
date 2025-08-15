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

Invoke-HttpRequest -u 'https://www.cloudflare.com'

Invoke-HttpRequest -o 'https' -s 'www.cloudflare.com'

Invoke-HttpRequest -o 'https' -s 'www.cloudflare.com' -p 'idontexist'

Invoke-HttpRequest -o 'https' -s 'github.com' -p '/seabopo'

Invoke-HttpRequest -o 'https' -s 'github.com' -p '/seabopo' -b

write-host ''
Invoke-HttpRequest -o 'https' -s 'github.com' -p '/seabopo' -b -l
