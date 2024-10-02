# PowerShellToolkit
A PowerShell module of helper functions.

## Write-StatusMessage
Writes formatted status messaged to the console. 

Messages can:
 - Be colorized by type (Success, Warning Error, etc...)
 - Be indented.
 - Be prefixed with a message type label.
 - Be prefixed with the date and time.
 - Be ignored/skipped by type via an environment variable.
 - Include pre or post spacing.
 - Include banners to easily distinguish between functional sections.
 - Include variables (complex objects are converted to JSON for debug logging).

Examples:
```
Write-StatusMessage -Type 'Process' -Message "Message" -Banner -DoubleSpace -PreSpace
  or
Write-Msg -t 'Warning' -m 'Message' -ba -ds -ps
  or
Write-Msg -w -m 'Message' -ba -ds -ps 

Write-StatusMessage -Type 'Debug' -Message 'Debug Message' -Labels -TimeStamps
  or 
Write-Msg -t 'Debug' -m 'Debug Message' -l -ts
  or
Write-Msg -d -m 'Debug Message' -l -ts
```

See /sample-code/Write-StatusMessage.samples.ps1 for more examples.

See /public/Write-StatusMessage.ps1 for usage documentation.


## Initialize-PipelineObject
This function is intended to be a data collection mechanism for longer workflows that need to collect and pass
data through a series of functions. This function includes the invocation history of all functions that called it,
and can optionally log the function calls and their input parameters for easier debugging.

When the PipelineObject is called it inspects the PowerShell function that invoked it and builds a HashTable which
contains a set of key/value pairs based on the invocation function's defined parameters.

The 'Initialize-PipelineObject' workflow is:
  1. Initialize a new PipelineObject hashtable if an existing hashtable was not passed to the object.
  2. Add the invocation data (call date, time, user, calling function, ect...) of the event to the 
     PipelineObject's '_InvocationData' property.
  3. Inspect the public definition of the function and add every user-defined parameter to the PipelineObject as
     a key with a null value.
  4. Determine if the PowerShell Common Parameters should be added and add the keys for those parameters if required.
  5. Loop through the bound parameters collection and set the value of each passed parameter.
  6. Loop through the defined parameters collection and set the value of any key that wasn't set by a bound parameter to the default value.
  7. Perform optional null-testing on user-specified parameters.
  8. Write an invocation log event, if logging is specified for the function.
  9. Write a parameter log even, if parameter logging is specified.

The PipelineObject contains 3 additional, custom properties when it is returned:
  1. Success = a boolean indicating whether the Initialize-PipelineObject process completed successfully.
  2. ResultMessage = a description of the initialization result, which will be the error message if success=$false.
  3. _Invocation = A hashtable containing the invocation history of the object, used for debug logging.

The PipelineObject includes a 'Tests' parameter, which allows you to perform some basic null testing. This 
parameter is provided because the values for a function may be passed to it via the PipelineObject and not
set by the bound parameters, which means that the 'Mandatory' parameter check can't be performed. This parameter
allows you to perform that basic check in the Initialize-PipelineObject call.

There are two types of value tests you can perform: 
 - **AnyIsNull** will fail the object initialization if any of the listed parameter names are null. Use this 
   to pass a list of required parameters to the initialization function.
 - **AllAreNull** will fail the object initialization if all of the listed parameter names are null. Use this 
   to pass a list of required parameters to the initialization function when only one of that list needs to have 
   a defined value (for example, if you have multiple parameter sets with a mandatory value in each set).

```
$Tests =  @{ 
              AnyIsNull = @('Parameter1','Parameter2'),
              AllAreNull = @('Parameter3','Parameter4'),
           }
$PipelineObject = Initialize-PipelineObject -Tests $Tests
```

### Documentation

See the /public/Initialize-PipelineObject.ps1 for usage documentation.  
The examples below are available for testing in /sample-code/Initialize-PipelineObject.readme_examples.ps1.  
See the /sample-code/Initialize-PipelineObject.samples.ps1 file for more usage examples.  


### PipelineObject Example 1

For example, in the following code ...
```
function Test-PipelineObject1 {

    param (
        [Parameter()] [String]   $StringParam       = 'Default text string 1',
        [Parameter()] [String]   $StringParam2      = 'Default text string 2',
        [Parameter()] [String]   $StringParam3,
        [Parameter()] [String[]] $StringArrayParam  = @('string1a','string1b'),
        [Parameter()] [Char]     $CharParam         = 'a',
        [Parameter()] [Byte]     $ByteParam         = 155,
        [Parameter()] [Int]      $IntParam          = 1234567890
    )

  # Create a new PipelineObject
    $PipelineObject = Initialize-PipelineObject

  # Add more data to it
    $PipelineObject.CharParam = 'b'
    $PipelineObject.StringParam4 = 'Default text string 4'

  # Write out the value of the pipeline object
    Write-Output $PipelineObject

}

$result = Test-PipelineObject1 -StringParam 'Custom String'
```
... the value of the $PipelineObject when it is returned is:
```
Name                           Value
----                           -----
CharParam                      b
StringParam                    Custom String
StringParam2                   Default text string 2
StringParam3                   
StringParam4                   Default text string 4
StringArrayParam               {string1a, string1b}
ByteParam                      155
IntParam                       1234567890
```

### PipelineObject Example 2

For example, in the following code ...
```
function Test-PipelineObject2 {

  param (
      [Parameter()] [String]   $StringParam       = 'Default text string 1',
      [Parameter()] [String]   $StringParam2      = 'Default text string 2',
      [Parameter()] [String]   $StringParam3,
      [Parameter()] [String[]] $StringArrayParam  = @('string1a','string1b'),
      [Parameter()] [Char]     $CharParam         = 'a',
      [Parameter()] [Byte]     $ByteParam         = 155,
      [Parameter()] [Int]      $IntParam          = 1234567890
  )

# Create a new PipelineObject
  $PipelineObject = Initialize-PipelineObject

# Add more data to it
  $PipelineObject.CharParam = 'b'
  $PipelineObject.StringParam4 = 'Default text string 4'

# Pass it to an additional function to add more data
  $PipelineObject | Add-MoreData2

}

function Add-MoreData2 {

  param (
    [Parameter()] [String] $StringParam4,
    [Parameter()] [String] $StringParam5,

    [Parameter(ValueFromPipeline)] [Hashtable] $PipelineObject = @{}
  )

# Append to pipeline object, instead of re-initializing it ( $PipelineObject = Initialize-PipelineObject ).
  $PipelineObject | Initialize-PipelineObject | Out-Null

# Append more data to it.
  $PipelineObject.StringParam6 = 'Default text string 6'

# Write it out to the pipleline for use by the calling cfunction.
  Write-Output $PipelineObject
}

$result = Test-PipelineObject2 -StringParam 'Custom String'
```

... the value of the $PipelineObject when it is returned is:
```
Name                           Value
----                           -----
CharParam                      b
StringParam                    Custom String
StringParam2                   Default text string 2
StringParam3                   
StringParam4                   Default text string 4
StringParam5                   
StringParam6                   Default text string 6
StringArrayParam               {string1a, string1b}
ByteParam                      155
IntParam                       1234567890
```

### PipelineObject Logging Example

You can enable logging for the PipelineObject with the following environment variables:
```
$env:PS_PIPELINEOBJECT_LOGGING   = $true
$env:PS_PIPELINEOBJECT_LOGVALUES = $true
```

If logging was enabled for the code in example 2, you would see the following events ...
```
Function Call: Test-PipelineObject called from Initialize-PipelineObject.samples.ps1 at 2024-09-22:16-08-56-994
... Bound Parameters: 
...... StringParam: Custom String

Function Call: Add-MoreData called from Test-PipelineObject at 2024-09-22:16-09-01-512
... Bound Parameters: 
...... PipelineObject: [Hashtable]
.........{
.........  "_Invocation": "System.Collections.Hashtable",
.........  "StringArrayParam": "string1a string1b",
.........  "Success": true,
.........  "ResultMessage": "PipelineObject updated.",
.........  "StringParam4": "Default text string 4",
.........  "StringParam2": "Default text string 2",
.........  "StringParam": "Custom String",
.........  "IntParam": 1234567890,
.........  "ByteParam": 155,
.........  "StringParam5": null,
.........  "StringParam3": null,
.........  "CharParam": "b"
.........}
```

### Using '' only for logging and error reporting.

If you don't have a need to collect and pass data through a complex pipeline, the PipelineObject is still useful
for logging your function calls and dumping debug data when an exception occurs.

This code:
```
function Test-PipelineObject4 {

  param (
      [Parameter()] [String]   $StringParam       = 'Default text string 1',
      [Parameter()] [String]   $StringParam2      = 'Default text string 2',
      [Parameter()] [String]   $StringParam3,
      [Parameter()] [String[]] $StringArrayParam  = @('string1a','string1b'),
      [Parameter()] [Char]     $CharParam         = 'a',
      [Parameter()] [Byte]     $ByteParam         = 155,
      [Parameter()] [Int]      $IntParam          = 1234567890
  )

# Create a new PipelineObject
  $PipelineObject, $InvocationID = Initialize-PipelineObject -ReturnInvocationID

  try {
      Throw 'This is a test exception'
  }
  catch {

    Write-Msg -Exception -Object $_

    Write-Msg -e -ps -m 'Function Invocation Data ' -o $PipelineObject._Invocation[$InvocationID] -rd 0

  }

}

$result = Test-PipelineObject4 -StringParam 'Custom String'
```

... would show the following log events:
```
Function Call: Test-PipelineObject4 called from Initialize-PipelineObject.readme_examples.ps1 at 2024-09-22:17-22-42-391
... Bound Parameters: 
...... StringParam: Custom String

Exception Error:
    Function: Test-PipelineObject4, line: 206
    Error Message: This is a test exception
    Code Statement: Throw 'This is a test exception'
    Stack Trace: 
        at Test-PipelineObject4, /Users/username/Repos/@psModules/psToolkit/sample-code/Initialize-PipelineObject.readme_examples.ps1: line 206
        at <ScriptBlock>, /Users/username/Repos/@psModules/psToolkit/sample-code/Initialize-PipelineObject.readme_examples.ps1: line 218
        at <ScriptBlock>, <No file>: line 1
    PowerShell: 7.4.1 Core on Unix

Function Invocation Data [Hashtable]
{
  "Time": "2024-09-22:17-22-42-391",
  "IgnoreParameterNames": "_Invocation",
  "Device": null,
  "DontLogParameters": false,
  "IncludeCommonParameters": false,
  "LogPipelineObjectValues": true,
  "BoundParameters": "System.Management.Automation.PSBoundParametersDictionary",
  "Tests": "System.Collections.Hashtable",
  "Account": "username",
  "EntryPointLineNumber": 203,
  "AllParameters": "System.Collections.Generic.Dictionary`2[System.String,System.Management.Automation.ParameterMetadata]",
  "PowerShellVersion": "7.4.1",
  "CallName": "Test-PipelineObject4",
  "ID": "Test-PipelineObject4::Initialize-PipelineObject.readme_examples.ps1::37fc023b-7b6b-4014-a7df-66d8d85c5ee6",
  "EntryPointStatement": "$PipelineObject, $InvocationID = Initialize-PipelineObject -ReturnInvocationID",
  "LogInvocation": true,
  "ModuleName": "",
  "PipelineObjectParameterName": null,
  "EntryPointPosition": "at Test-PipelineObject4, /Users/username/Repos/@psModules/psToolkit/sample-code/Initialize-PipelineObject.readme_examples.ps1: line 203",
  "PowerShellOS": "Darwin 23.6.0 Darwin Kernel Version 23.6.0: Mon Jul 29 21:14:30 PDT 2024; root:xnu-10063.141.2~1/RELEASE_ARM64_T6000",
  "PowerShellEdition": "Core",
  "CommandName": "Test-PipelineObject4",
  "Command": "Test-PipelineObject4",
  "PowerShellPlatform": "Unix",
  "InvokedFromName": "Initialize-PipelineObject.readme_examples.ps1"
}
```
