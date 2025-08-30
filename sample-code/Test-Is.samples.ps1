#==================================================================================================================
#==================================================================================================================
# Sample Code :: Test-Is
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

Write-Msg -h -ps -bb -m $( ' Test-Is :: $null' )
Test-Is($null) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-IsNothing :: $null' )
Test-IsNothing($null) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-IsSomething :: Empty String' )
Test-IsSomething('') | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: String' )
Test-Is('A String') | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: String Array' )
Test-Is(@('A','String','Array')) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: Int' )
Test-Is(147) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: Zero Int' )
[int] $value = 0
Test-Is($value) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: Int Array' )
Test-Is(@(147,150,199)) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: Empty Array' )
Test-Is(@()) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: Double' )
Test-Is(147.741) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: DateTime' )
Test-Is(@(Get-Date)) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: Hashtable' )
[Hashtable] $testHashTable = @{ID = 1; Name = 'Name'}
Test-Is($testHashTable) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: Empty Hashtable' )
[Hashtable] $testHashTable = @{}
Test-Is($testHashTable) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: ArrayList' )
$myArrayList = [System.Collections.ArrayList]@()
$newItems = @("Item 1", "Item 2", "Item 3", "Item 4")
$myArrayList.AddRange($newItems)
Test-Is($myArrayList) | Out-Null

Write-Msg -h -ps -bb -m $( ' Test-Is :: Empty ArrayList' )
$myArrayList = [System.Collections.ArrayList]@()
Test-Is($myArrayList) | Out-Null

exit
