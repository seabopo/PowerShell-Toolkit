#==================================================================================================================
#==================================================================================================================
# Sample Code :: Write-StatusMessage
#==================================================================================================================
#==================================================================================================================

#==================================================================================================================
# Initialize Test Environment
#==================================================================================================================

Clear-Host

Set-Location  -Path $PSScriptRoot
Push-Location -Path $PSScriptRoot

$ErrorActionPreference = "Stop"

# Set these control variables to determine the categories of certain functions

# Determine which types of messages should be considered "verbose", and decide whether or not to show them.
  $env:PS_STATUSMESSAGE_IGNORE_MESSAGE_TYPES  = '[]'
  $env:PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES = '["Debug","Information"]'
  $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $true

# Determine which types of messages should have label (a 'Type' prefix), and decide whether or not to show them.
  $env:PS_STATUSMESSAGE_LABEL_MESSAGE_TYPES = '["Debug","Success","Warning","Failure","Error","Exception"]'

# Set global overrides of the function-level parameters. The default values are used below.
  $env:PS_STATUSMESSAGE_LABELS              = $false
  $env:PS_STATUSMESSAGE_TIMESTAMPS          = $false
  $env:PS_STATUSMESSAGE_INDENTATION_STRING  = '...'
  $env:PS_STATUSMESSAGE_BANNER_STRING       = '-'
  $env:PS_STATUSMESSAGE_BANNER_LENGTH       = 80
  $env:PS_STATUSMESSAGE_COLOR_BANNERS       = $false
  $env:PS_STATUSMESSAGE_MAX_RECURSION_DEPTH = 10
  $env:PS_STATUSMESSAGE_RETHROW_EXCEPTIONS  = $false

# Import the module to be tested.
  Import-Module '../po.Toolkit/' -Force

#==================================================================================================================
# Run Status Message Tests
#==================================================================================================================

Write-StatusMessage -Type 'Header' -Message " Basic Status Message Examples" -DoubleBanner -ColorBanners -PreSpace

#-------------------------------------------------------------------------------
# Test #B-1: Type Parameter as String Value Tests (Full Name)
#-------------------------------------------------------------------------------

Write-StatusMessage -Type 'Process' -Message " Test #B-1: Type Parameter as String Value Tests (Full Name)" -Banner -DoubleSpace -PreSpace

Write-StatusMessage -Type 'Header'             -Message 'Header Message ...'      -Labels -TimeStamps
Write-StatusMessage -Type 'Process'            -Message 'Process Message ...'     -Labels -TimeStamps
Write-StatusMessage -Type 'Action'             -Message 'Action Message ...'      -Labels -TimeStamps
Write-StatusMessage -Type 'Information'        -Message 'Information Message ...' -Labels -TimeStamps
Write-StatusMessage -Type 'Debug'              -Message 'Debug Message ...'       -Labels -TimeStamps
Write-StatusMessage -Type 'Success'            -Message 'Success Message ...'     -Labels -TimeStamps
Write-StatusMessage -Type 'Warning'            -Message 'Warning Message ...'     -Labels -TimeStamps
Write-StatusMessage -Type 'Failure'            -Message 'Failure Message ...'     -Labels -TimeStamps
Write-StatusMessage -Type 'Error'              -Message 'Error Message ...'       -Labels -TimeStamps
Write-StatusMessage -Type 'Exception'          -Message 'Exception Message ...'   -Labels -TimeStamps
Write-StatusMessage -Type 'InvocationSource'                                      -Labels -TimeStamps

#-------------------------------------------------------------------------------
# Test #B-2: Type Parameter as String Value Tests (Alias)
#-------------------------------------------------------------------------------

Write-StatusMessage -t 'Process' -m " Test #B-2: Type Parameter as String Value Tests (Alias)" -b -ds -ps

Write-StatusMessage -t 'Header'           -m 'Header Message ...'      -l -ts
Write-StatusMessage -t 'Process'          -m 'Process Message ...'     -l -ts
Write-StatusMessage -t 'Action'           -m 'Action Message ...'      -l -ts
Write-StatusMessage -t 'Information'      -m 'Information Message ...' -l -ts
Write-StatusMessage -t 'Debug'            -m 'Debug Message ...'       -l -ts
Write-StatusMessage -t 'Success'          -m 'Success Message ...'     -l -ts
Write-StatusMessage -t 'Warning'          -m 'Warning Message ...'     -l -ts
Write-StatusMessage -t 'Failure'          -m 'Failure Message ...'     -l -ts
Write-StatusMessage -t 'Error'            -m 'Error Message ...'       -l -ts
Write-StatusMessage -t 'Exception'        -m 'Exception Message ...'   -l -ts
Write-StatusMessage -t 'InvocationSource'                              -l -ts

#-------------------------------------------------------------------------------
# Test #B-3: Type Parameter as Switch Value Tests (Full Name)
#-------------------------------------------------------------------------------

Write-StatusMessage -Type 'Process' -Message " Test #B-3: Type Parameter as Switch Value Tests (Full Name)" -Banner -DoubleSpace -PreSpace

Write-StatusMessage -Header             -Message 'Header Message ...'     
Write-StatusMessage -Process            -Message 'Process Message ...'    
Write-StatusMessage -Action             -Message 'Action Message ...'     
Write-StatusMessage -Information        -Message 'Information Message ...'
Write-StatusMessage -Dbg                -Message 'Debug Message ...'      
Write-StatusMessage -Success            -Message 'Success Message ...'    
Write-StatusMessage -Warning            -Message 'Warning Message ...'    
Write-StatusMessage -Failure            -Message 'Failure Message ...'    
Write-StatusMessage -Err                -Message 'Error Message ...'      
Write-StatusMessage -Exception          -Message 'Exception Message ...'  
Write-StatusMessage -InvocationSource                                     

#-------------------------------------------------------------------------------
# Test #B-4: Type Parameter as Switch Value Tests (Alias)
#-------------------------------------------------------------------------------

Write-StatusMessage -p -m " Test #B-4: Type Parameter as Switch Value Tests (Alias)" -b -ds -ps

Write-StatusMessage -h -m 'Header Message ...'     
Write-StatusMessage -p -m 'Process Message ...'    
Write-StatusMessage -a -m 'Action Message ...'     
Write-StatusMessage -i -m 'Information Message ...'
Write-StatusMessage -d -m 'Debug Message ...'      
Write-StatusMessage -s -m 'Success Message ...'    
Write-StatusMessage -w -m 'Warning Message ...'    
Write-StatusMessage -f -m 'Failure Message ...'    
Write-StatusMessage -e -m 'Error Message ...'      
Write-StatusMessage -x -m 'Exception Message ...'  
Write-StatusMessage -v                             

#-------------------------------------------------------------------------------
# Test #B-5: Test Indentation Levels with names and labels
#-------------------------------------------------------------------------------

Write-StatusMessage -p -m " Test #B-5:  Test Indentation Levels with full names and labels" -b -ds -ps

Write-StatusMessage -Type 'Action'           -Message 'Level 0 ...' -Labels -TimeStamps -IndentationLevel 0
Write-StatusMessage -Type 'Action'           -Message 'Level 1 ...' -Labels -TimeStamps -IndentationLevel 1
Write-StatusMessage -Type 'Action'           -Message 'Level 2 ...' -Labels -TimeStamps -IndentationLevel 2
Write-StatusMessage -Type 'Action'           -Message 'Level 3 ...' -Labels -TimeStamps -IndentationLevel 3
Write-StatusMessage -Type 'Action'           -Message 'Level 4 ...' -Labels -TimeStamps -IndentationLevel 4
Write-StatusMessage -Type 'Debug'            -Message 'Level 4 ...' -Labels -TimeStamps -IndentationLevel 4
Write-StatusMessage -Type 'Success'          -Message 'Level 4 ...' -Labels -TimeStamps -IndentationLevel 4
Write-StatusMessage -Type 'Warning'          -Message 'Level 4 ...' -Labels -TimeStamps -IndentationLevel 4
Write-StatusMessage -Type 'Error'            -Message 'Level 4 ...' -Labels -TimeStamps -IndentationLevel 4
Write-StatusMessage -Type 'Exception'        -Message 'Level 4 ...' -Labels -TimeStamps -IndentationLevel 4
Write-StatusMessage -Type 'InvocationSource' -Message 'Level 4 ...' -Labels -TimeStamps -IndentationLevel 4

#-------------------------------------------------------------------------------
# Test #B-6: Test Indentation Levels with names and labels
#-------------------------------------------------------------------------------

Write-StatusMessage -p -m " Test #B-6: Test Indentation Levels with switches and no labels" -b -ds -ps

Write-StatusMessage -a -m 'Level 0 ...' -il 0
Write-StatusMessage -a -m 'Level 1 ...' -il 1
Write-StatusMessage -a -m 'Level 2 ...' -il 2
Write-StatusMessage -a -m 'Level 3 ...' -il 3
Write-StatusMessage -a -m 'Level 4 ...' -il 4
Write-StatusMessage -d -m 'Level 4 ...' -il 4
Write-StatusMessage -s -m 'Level 4 ...' -il 4
Write-StatusMessage -w -m 'Level 4 ...' -il 4
Write-StatusMessage -e -m 'Level 4 ...' -il 4
Write-StatusMessage -x -m 'Level 4 ...' -il 4
Write-StatusMessage -v                  -il 4

#-------------------------------------------------------------------------------
# Test #B-7: Test Default Environment Variables DISABLED
#-------------------------------------------------------------------------------

Write-StatusMessage -p -m " Test #B-7: Test Default Environment Variables DISABLED" -b -ds -ps

$env:PS_STATUSMESSAGE_LABELS     = $false
$env:PS_STATUSMESSAGE_TIMESTAMPS = $false

Write-StatusMessage -h -m 'Header Message ...'
Write-StatusMessage -p -m 'Process Message ...'
Write-StatusMessage -a -m 'Action Message ...'
Write-StatusMessage -i -m 'Information Message ...'
Write-StatusMessage -d -m 'Debug Message ...'
Write-StatusMessage -s -m 'Success Message ...'
Write-StatusMessage -w -m 'Warning Message ...'
Write-StatusMessage -f -m 'Failure Message ...'
Write-StatusMessage -e -m 'Error Message ...'
Write-StatusMessage -x -m 'Exception Message ...'
Write-StatusMessage -v

#-------------------------------------------------------------------------------
# Test #B-8: Test Default Environment Variables ENABLED
#-------------------------------------------------------------------------------

Write-StatusMessage -p -m " Test #B-8: Test Default Environment Variables ENABLED" -b -ds -ps

$env:PS_STATUSMESSAGE_LABELS     = $true
$env:PS_STATUSMESSAGE_TIMESTAMPS = $true

Write-StatusMessage -h -m 'Header Message ...'
Write-StatusMessage -p -m 'Process Message ...'
Write-StatusMessage -a -m 'Action Message ...'
Write-StatusMessage -i -m 'Information Message ...'
Write-StatusMessage -d -m 'Debug Message ...'
Write-StatusMessage -s -m 'Success Message ...'
Write-StatusMessage -w -m 'Warning Message ...'
Write-StatusMessage -f -m 'Failure Message ...'
Write-StatusMessage -e -m 'Error Message ...'
Write-StatusMessage -x -m 'Exception Message ...'
Write-StatusMessage -v

$env:PS_STATUSMESSAGE_LABELS     = $false
$env:PS_STATUSMESSAGE_TIMESTAMPS = $false

#==================================================================================================================
# Run Debug Object Tests
#==================================================================================================================

Write-StatusMessage -Type 'Header' -Message " Debug Object Examples" -DoubleBanner -ColorBanners -PreSpace

[String]    $testString = "Test String"
[Int]       $testInt    = 123
[Bool]      $testBool   = $true
[String[]]  $testArray  = @("Test Array Item 1", "Test Array Item 2", "Test Array Item 3")

[Object]    $testObject = New-Object -TypeName PSObject -Property @{
                              PropertyName1 = "Property Value 1"
                              PropertyName2 = "Property Value 2"
                          }

[HashTable] $testHashTable = @{
                                PropertyName1 = "Property Value 1"
                                PropertyName2 = "Property Value 2"
                              }

$complexObject = @{

    Movies = @(
        @{
            Title = 'Movie 1'
            Year = 2021
            Genres = @('Action','Adventure','Sci-Fi')
            Actors = @(
                @{ Actor = 'Actor 1'; Role = 'Role 1' }
                @{ Actor = 'Actor 2'; Role = 'Role 2' }
            )
        },
        @{
            Title = 'Movie 2'
            Year = 2021
            Genres = @('Action','Adventure','Fantasy')
            Actors = @(
                @{ Actor = 'Actor 1'; Role = 'Role 1' }
                @{ Actor = 'Actor 2'; Role = 'Role 2' }
                @{ Actor = 'Actor 3'; Role = 'Role 3' }
            )
        },
        @{
            Title = 'Movie 1'
            Year = 2021
            Genres = @('Action','Adventure','Western')
            Actors = @(
                @{ Actor = 'Actor 1'; Role = 'Role 1' }
                @{ Actor = 'Actor 2'; Role = 'Role 2' }
                @{ Actor = 'Actor 3'; Role = 'Role 3' }
                @{ Actor = 'Actor 4'; Role = 'Role 4' }
            )
        }
    )
    TelevisionShows = @(
        @{
            Title = 'Show 1'
            Year = 2021
            Genres = @('Action','Adventure','Sci-Fi')
            Actors = @(
                @{ Actor = 'Actor 1'; Role = 'Role 1' }
                @{ Actor = 'Actor 2'; Role = 'Role 2' }
            )
            Seasons = @(
                @{
                    Season = 1
                    Episodes = @(
                        @{ Episode = 1; Title = 'Episode 1'; Description = 'Episode 1 Description' }
                        @{ Episode = 2; Title = 'Episode 2'; Description = 'Episode 2 Description' }
                    )
                },
                @{
                    Season = 2
                    Episodes = @(
                        @{ Episode = 1; Title = 'Episode 1'; Description = 'Episode 1 Description' }
                        @{ Episode = 2; Title = 'Episode 2'; Description = 'Episode 2 Description' }
                    )
                }
            )
        },
        @{
            Title = 'Show 2'
            Year = 2021
            Genres = @('Action','Adventure','Fantasy')
            Actors = @(
                @{ Actor = 'Actor 1'; Role = 'Role 1' }
                @{ Actor = 'Actor 2'; Role = 'Role 2' }
                @{ Actor = 'Actor 3'; Role = 'Role 3' }
            )
            Seasons = @(
                @{
                    Season = 1
                    Episodes = @(
                        @{ Episode = 1; Title = 'Episode 1'; Description = 'Episode 1 Description' }
                        @{ Episode = 2; Title = 'Episode 2'; Description = 'Episode 2 Description' }
                    )
                },
                @{
                    Season = 2
                    Episodes = @(
                        @{ Episode = 1; Title = 'Episode 1'; Description = 'Episode 1 Description' }
                        @{ Episode = 2; Title = 'Episode 2'; Description = 'Episode 2 Description' }
                    )
                }
            )
        }
    )
}

#-------------------------------------------------------------------------------
# Test #D-1: Basic Debug Object Examples
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #D-1: Basic Debug Object Examples" -b -ds -ps

Write-Msg -d -ds -m 'Debug Object: ' -o $testString
Write-Msg -d -ds -m 'Debug Object: ' -o $testInt
Write-Msg -d -ds -m 'Debug Object: ' -o $testBool
Write-Msg -d -ds -m 'Debug Object: ' -o $testArray
Write-Msg -d -ds -m 'Debug Object: ' -o $testObject
Write-Msg -d -ds -m 'Debug Object: ' -o $testHashTable

#-------------------------------------------------------------------------------
# Test #D-2: Complex Debug Object
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #D-2: Complex Debug Object with 3 levels of Recursion" -b -ds -ps

Write-Msg -d -ds -m 'Debug Object: ' -o $complexObject -MaxRecursionDepth 3

#-------------------------------------------------------------------------------
# Test #D-3: Complex Debug Object
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #D-3: Complex Debug Object with Indentation and Full Recursion" -b -ds -ps
Write-Msg -d -il 1 -ds -m 'Debug Object: ' -o $complexObject -MaxRecursionDepth 30

#==================================================================================================================
# Variable Type Parameter Tests
#==================================================================================================================

Write-StatusMessage -Type 'Header' -Message " Variable Type Parameter Tests" -DoubleBanner -ColorBanners -PreSpace

#-------------------------------------------------------------------------------
# Test #V-1: Success or Failure Message Type
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #V-1: Success or Failure Message Type" -b -ds -ps

#-------------------------------------------------------------------------------
# Test #V-2: Success or Warning Message Type
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #V-2: Success or Warning Message Type" -b -ds -ps

#-------------------------------------------------------------------------------
# Test #V-3: Action or Failure Message Type
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #V-3: Action or Failure Message Type" -b -ds -ps

#-------------------------------------------------------------------------------
# Test #V-4: Action or Warning Message Type
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #V-4: Action or Warning Message Type" -b -ds -ps


#==================================================================================================================
# Function Call Tests
#==================================================================================================================

Write-StatusMessage -Type 'Header' -Message " Function Call Tests" -DoubleBanner -ColorBanners -PreSpace

#-------------------------------------------------------------------------------
# Test #F-1: Function Call Examples
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #F-1: Function Call and Function Result Logging" -b -ps

function Invoke-FunctionCall1 {
    Write-Msg -FunctionCall 
    Write-Msg -FunctionResult -Message "Invoke-FunctionCall1 Test Message"
}
Invoke-FunctionCall1

#-------------------------------------------------------------------------------
# Test #F-2: Function Call Examples
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #F-2: Function Call and Function Result Logging with debug object" -b -ps

function Invoke-FunctionCall2 {
    param(   
        [Parameter()] [String] $TestParam1,
        [Parameter()] [String] $TestParam2,
        [Parameter()] [Switch] $ForceWrite
    )
    $testParam3 = @{
        TestParam3a = "Test Value 3a"
        TestParam3b = "Test Value 3b"
    }
    Write-Msg -FunctionCall -IncludeParameters -ForceWrite:$ForceWrite
    Write-Msg -FunctionResult -Message "Invoke-FunctionCall2 Result Message" -object $testParam3 -ForceWrite:$ForceWrite
}
Invoke-FunctionCall2 -TestParam1 'Test Value 1' -TestParam2 'Test Value 2'

#-------------------------------------------------------------------------------
# Test #F-3: Function Call Examples with Verbose Messages Disabled
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #F-3: Function Call with Verbose Messages Disabled" -b -ps
$env:PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES = '["Process","Debug","Information"]'
$env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $false
Invoke-FunctionCall2 -TestParam1 'Test Value 1' -TestParam2 'Test Value 2'

#-------------------------------------------------------------------------------
# Test #F-4: Test #F-4: Function Call with Function Messages Ignored but Forced
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #F-4: Function Call with Function Messages Ignored but Forced" -b -ps -fw
$env:PS_STATUSMESSAGE_IGNORE_MESSAGE_TYPES  = '["FunctionCall","FunctionResult"]'
$env:PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES = '["Process","Debug","Information"]'
$env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $false
Invoke-FunctionCall2 -TestParam1 'Test Value 1' -TestParam2 'Test Value 2' -ForceWrite

$env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $true

#==================================================================================================================
# Run Exception Error Tests
#==================================================================================================================

Write-StatusMessage -Type 'Header' -Message " Function Call Tests" -DoubleBanner -ColorBanners -PreSpace

#-------------------------------------------------------------------------------
# Test #X-1: Auto-Generated Exception Message Examples
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #X-1: Auto-Generated Exception Message Examples" -b -ds -ps

function Invoke-ErrorTest1 {

    Write-Msg -w -m "Generate a custom error message." -ds
    try {
        write-host ('test:{0}{3}' -f 'red','green')
    }
    catch {
        Write-Msg -x -m "custom error message`r`n" -o $_
    }

}
Invoke-ErrorTest1

#-------------------------------------------------------------------------------
# Test #X-2: Auto-Generated Exception Message Examples
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #X-2: Auto-Generated Exception Message Examples" -b -ds -ps

function Invoke-ErrorTest2 {

    Write-Msg -w -m "Generate an automatically handled exception message."
    try {
        Invoke-NonExistentFunction
    }
    catch {
        Write-Msg -x -o $_
    }

}
Invoke-ErrorTest2

#-------------------------------------------------------------------------------
# Test #X-3: Test re-throwing an exception.
#-------------------------------------------------------------------------------

Write-Msg -p -m " Test #X-3: Test re-throwing an exception (TESTS END HERE!!!)." -b -ds -ps

function Invoke-ErrorTest3 {

    Write-Msg -w -m "Test re-throwing an exception."
    $env:PS_STATUSMESSAGE_RETHROW_EXCEPTIONS = $true
    try {
        Invoke-NonExistentFunction
    }
    catch {
        Write-Msg -x -o $_
    }

}
Invoke-ErrorTest3 -ErrorAction SilentlyContinue

#==================================================================================================================
# PowerShell Color Tests
#==================================================================================================================

Write-Host "Testing Color: Red"         -ForegroundColor Red
Write-Host "Testing Color: DarkRed"     -ForegroundColor DarkRed
Write-Host "Testing Color: Yellow"      -ForegroundColor Yellow
Write-Host "Testing Color: DarkYellow"  -ForegroundColor DarkYellow
Write-Host "Testing Color: Green"       -ForegroundColor Green
Write-Host "Testing Color: DarkGreen"   -ForegroundColor DarkGreen
Write-Host "Testing Color: Cyan"        -ForegroundColor Cyan
Write-Host "Testing Color: DarkCyan"    -ForegroundColor DarkCyan
Write-Host "Testing Color: Blue"        -ForegroundColor Blue
Write-Host "Testing Color: DarkBlue"    -ForegroundColor DarkBlue
Write-Host "Testing Color: Magenta"     -ForegroundColor Magenta
Write-Host "Testing Color: DarkMagenta" -ForegroundColor DarkMagenta
Write-Host "Testing Color: Gray"        -ForegroundColor Gray
Write-Host "Testing Color: DarkGray"    -ForegroundColor DarkGray
Write-Host "Testing Color: White"       -ForegroundColor White

