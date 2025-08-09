function Write-StatusMessage {
    <#
    .DESCRIPTION
        Writes a formatted status message to the console.

    .PARAMETER Message
        REQUIRED. String. Alias: -m. The message to be written to the console.

    .PARAMETER Type
        OPTIONAL. String. Alias: -t. The type of message to write. Default value: 'Action'.

        The type determines several properties of the output, including the color, label and when the messages
        are suppressed. The type of message can also be set using the following switches: 
        -Header, -Process, -FunctionCall, -FunctionResult, -InvocationSource, 
        -Action, -Information, -Dbg, -Success, -Warning, -Failure, -Err -ExceptionError

        Message types of Header, Process, Information, Debug, InvocationSource and FunctionCall are by default 
        considered verbose and are only shown when the PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES is set to true. 
        This list can be modified by updating the PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES environment variable. 
        The value of this variable must be a JSON array of strings as environment variables can only store strings.
        Examples:
            $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES = $true
            $env:PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES = '["Header","Process","Debug","Information"]'

        All messages are written using the Write-Host PowerShell function as that is the only function 
        that supports color-coding of messages.

            Type             Msg Color    Msg Header   Verbose 
            ---------------  -----------  -----------  ------- 
            Header           Magenta      -none-       Yes     
            Process          Cyan         -none-       Yes     
            FunctionCall     Blue         -none-       Yes     
            InvocationSource Gray         -none-       Yes     
            FunctionResult   DarkBlue     -none-       Yes     
            Information      DarkGray     -none-       Yes     
            Debug            DarkGray     DEBUG        Yes     
            Action           White        -none-       No      
            Success          DarkGreen    SUCCESS      No      
            Warning          DarkYellow   WARNING      No      
            Failure          DarkRed      FAILURE      No      
            Error            Red          ERROR        No      
            Exception        Red          EXCEPTION    No      
            

        Note: Specific types of messages can be ignored by setting the PS_STATUSMESSAGE_IGNORE_MESSAGE_TYPES
              environment variable. The value of this variable must be a JSON array of strings.
              Example: $env:PS_STATUSMESSAGE_IGNORE_MESSAGE_TYPES  = '["InvocationSource","FunctionCall"]'

    .PARAMETER Header
        OPTIONAL. Switch. Alias: -h. Switch alternative for the Header Type parameter. Message Color: Magenta.
        Header messages are only shown when the PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES environment variable is
        set to true. This can be changed by updating the PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES environment
        variable.

    .PARAMETER Process
        OPTIONAL. Switch. Alias: -p. Switch alternative for the Process Type parameter. Message Color: Cyan.
        Process messages are only shown when the PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES environment variable is
        set to true. This can be changed by updating the PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES environment
        variable.

    .PARAMETER Action
        OPTIONAL. Switch. Alias: -a. Switch alternative for the Action Type parameter. Message Color: Gray.
        Action is the default message type if no type is specified. Action messages are always shown.

    .PARAMETER Information
        OPTIONAL. Switch. Alias: -i. Switch alternative for the Information Type parameter. Message Color: DarkGray.
        Information messages are only shown when the PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES environment variable is
        set to true. This can be changed by updating the PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES environment
        variable.

    .PARAMETER Dgb
        OPTIONAL. Switch. Alias: -d. Switch alternative for the Debug Type parameter. Message Color: DarkGray.
        Debug messages are only shown when the PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES environment variable is
        set to true. This can be changed by updating the PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES environment
        variable.

    .PARAMETER Success
        OPTIONAL. Switch. Alias: -s. Switch alternative for the Success Type parameter. Message Color: Green.

    .PARAMETER Warning
        OPTIONAL. Switch. Alias: -w. Switch alternative for the Warning Type parameter. Message Color: Yellow.

    .PARAMETER Failure
        OPTIONAL. Switch. Alias: -f. Switch alternative for the Failure Type parameter. Message Color: Red.

    .PARAMETER Err
        OPTIONAL. Switch. Alias: -e. Switch alternative for the Error Type parameter. Message Color: Red.

    .PARAMETER Exception
        OPTIONAL. Switch. Alias: -x. Switch alternative for the Exception Type parameter. Message Color: Red.
        Assigning the Error object to the MessageObject parameter for this type of message will automatically
        generate an exception message based on the error details and append it to the message parameter.

    .PARAMETER InvocationSource
        OPTIONAL. Switch. Alias: -v. Switch alternative for the InvocationSource Type parameter. Message Color: Gray.
        Sets the message to the source of the callstack that called the parent function. Note that this will not
        work correctly when called directly from a script file or the console as the callstack will not be 
        correctly set.

    .PARAMETER FunctionCall
        OPTIONAL. Switch. Alias: -c. Switch alternative for the FunctionCall Type parameter.
        Writes four messages logging the function name (Process Type), the function file (debug type), the
        invocation source (debut type) and the invocation file (debut type).

    .PARAMETER FunctionResult
        OPTIONAL. Switch. Alias: -r. Switch alternative for the FunctionResult Type parameter.
        Writes two messages logging the function name (Process Type) and the return value (Debug Type).

    .PARAMETER IncludeParameters
        OPTIONAL. Switch. Alias: -ip. If the message type is 'FunctionCall' this parameter will also log
        the parameters that were bound to the function call.

    .PARAMETER TimeStamps
        OPTIONAL. Switch. Alias: -ts. Prefixes each message with a timestamp in the format" 'yyyy-MM-dd HH:mm:ss'.
        This value can be set using an environment variable.
            Example: $env:PS_STATUSMESSAGE_TIMESTAMPS = $true

    .PARAMETER Labels
        OPTIONAL. Switch. Alias: -l. Prefixes each message with the message type.
        Labels: DEBUG, SUCCESS, FAILURE, WARNING, ERROR, EXCEPTION.
        Messages with the Header, Process, and Information types will not have labels by default.
        This value can be set using an environment variable.
            Example: $env:PS_STATUSMESSAGE_LABELS = $true
        The Types of messages that use labels can also be set using an environment variable.
            Example: $env:PS_STATUSMESSAGE_LABEL_MESSAGE_TYPES = '["Debug","Success","Warning","Failure",...]'
        You must specify the array in JSON format since environment variables can only store strings.

    .PARAMETER IndentationLevel
        OPTIONAL. Integer. Alias: -il. Indents the message using the string specified by the IndentationString
        parameter. This value is a multiplier for the IndentationString, so an IndentationString value of 3
        periods ('...') and an IndentationLevel value of 2 will indent the message by 6 periods ('......').
        Default value: 0.

    .PARAMETER IndentationString
        OPTIONAL. String. Alias: -is. A string of characters used for indentation. Default value: '...'.
        This value can be set using an environment variable.
            Example: $env:PS_STATUSMESSAGE_INDENTATION_STRING = '...'

    .PARAMETER Banner
        OPTIONAL. Switch. Alias: -b. Writes a line of characters above and below the message to make it more
        visible. The characters used for the banner are set by the BannerString parameter. The length of the banner
        is determined by the BannerLength parameter.

    .PARAMETER DoubleBanner
        OPTIONAL. Switch. Alias: -bb. Writes two lines of characters above and below the message to make it more
        visible. The characters used for the banner are set by the BannerString parameter. The length of the banner
        is determined by the BannerLength parameter.

    .PARAMETER BannerString
        OPTIONAL. String. Alias: -bs. A string of one or more characters to use as a console banner. This string
        will be repeated to create a banner. Default value: '='.
        This value can be set using an environment variable.
            Example: $env:PS_STATUSMESSAGE_BANNER_STRING = '='

    .PARAMETER BannerLength
        OPTIONAL. Integer. Alias: -bl. The length of the banner to write above and below the message. The value of
        the BannerString parameter will be repeated as necessary to create this line length. Extra characters will
        be truncated.  Default value: 80.
        This value can be set using an environment variable.
            Example: $env:PS_STATUSMESSAGE_BANNER_LENGTH = 80

    .PARAMETER ColorBanners
        OPTIONAL. Switch. Alias: -cb. Colors the banners to match the message type. Default value: $true.
        This value can be set using an environment variable.
            Example: $env:PS_STATUSMESSAGE_COLOR_BANNERS = $true

    .PARAMETER DoubleSpace
        OPTIONAL. Switch. Alias: -ds. Adds a blank line after the logged item.

    .PARAMETER PreSpace
        OPTIONAL. Switch. Alias: -ps. Adds a blank line before the logged item.

    .PARAMETER RethrowException
        OPTIONAL. Switch. Alias: -rx. Re-throws the exception after writing the log message.

    .PARAMETER Object
        OPTIONAL. Alias: -o. An object whose properties will be written to the console. The object is
        converted to a JSON object for display to the screen.

    .PARAMETER MaxRecursionDepth
        OPTIONAL. Integer. Alias: -rd. The maximum depth of recursion when converting the item specified by the
        object parameter to a JSON string. Default value: 3. The PowerShell maximum value is 100.
        This value can be set using an environment variable.
            Example: $env:PS_STATUSMESSAGE_MAX_RECURSION_DEPTH = 10

    .PARAMETER ForceWrite
        OPTIONAL. Switch. Alias: -fw. Forces the message to be written to the console even if the message type
        would normally be suppressed because the message type is in the Verbose or Ignore lists.

    .EXAMPLE
        Write-StatusMessage -Type 'Header' -Message 'Starting Testing ...'

    .EXAMPLE
        Write-Status -Type 'Header' -Message 'Starting Testing ...'

    .EXAMPLE
        Write-Message -i -m 'Testing ...'

    .EXAMPLE
        Write-Msg -i -m 'Testing ...'
    #>

    [OutputType([void])]
    [CmdletBinding(DefaultParameterSetName = "isInformation")]
    [Alias('Write-Status','Write-Message','Write-Msg')]
    param (

        [Parameter()]
        [AllowEmptyString()][AllowNull()]
        [Alias('m')]  [string]         $Message,

        [Parameter(ParameterSetName = "byTypeName")]
        [ValidateSet('Header','Process','Action','Information','Debug',
                     'Success','Warning','Failure','Error','Exception',
                     'InvocationSource','FunctionCall','FunctionResult')]
        [Alias('t')]  [String]         $Type,

        [Parameter(ParameterSetName = "Header")]
        [Alias('h')]  [Switch]        $Header,

        [Parameter(ParameterSetName = "Process")]
        [Alias('p')]  [Switch]        $Process,

        [Parameter(ParameterSetName = "Action")]
        [Alias('a')]  [Switch]        $Action,

        [Parameter(ParameterSetName = "Information")]
        [Alias('i')]  [Switch]        $Information,

        [Parameter(ParameterSetName = "Debug")]
        [Alias('d')]  [Switch]        $Dbg,

        [Parameter(ParameterSetName = "Success")]
        [Alias('s')]  [Switch]        $Success,

        [Parameter(ParameterSetName = "Warning")]
        [Alias('w')]  [Switch]        $Warning,

        [Parameter(ParameterSetName = "Failure")]
        [Alias('f')]  [Switch]        $Failure,

        [Parameter(ParameterSetName = "Error")]
        [Alias('e')]  [Switch]        $Err,

        [Parameter(ParameterSetName = "Exception")]
        [Alias('x')]  [Switch]        $Exception,

        [Parameter(ParameterSetName = "InvocationSource")]
        [Alias('v')]  [Switch]        $InvocationSource,

        [Parameter(ParameterSetName = "FunctionCall")]
        [Alias('c')]  [Switch]        $FunctionCall,
        [Alias('ip')] [Switch]        $IncludeParameters,

        [Parameter(ParameterSetName = "FunctionResult")]
        [Alias('r')]  [Switch]        $FunctionResult,
        
        [Alias('ts')] [Switch]        $TimeStamps = [System.Convert]::ToBoolean($env:PS_STATUSMESSAGE_TIMESTAMPS),
        [Alias('l')]  [Switch]        $Labels     = [System.Convert]::ToBoolean($env:PS_STATUSMESSAGE_LABELS),

        [Alias('il')] [Int]           $IndentationLevel = 0,
        [Alias('is')] [String]        $IndentationString = $env:PS_STATUSMESSAGE_INDENTATION_STRING,

        [Alias('b')]  [Switch]        $Banner,
        [Alias('bb')] [Switch]        $DoubleBanner,
        [Alias('bs')] [String]        $BannerString = $env:PS_STATUSMESSAGE_BANNER_STRING,
        [Alias('bl')] [Int]           $BannerLength = [System.Convert]::ToInt32($env:PS_STATUSMESSAGE_BANNER_LENGTH),
        [Alias('cb')] [Switch]        $ColorBanners = [System.Convert]::ToBoolean($env:PS_STATUSMESSAGE_COLOR_BANNERS),

        [Alias('rx')] [Switch]        $RethrowException = [System.Convert]::ToBoolean($env:PS_STATUSMESSAGE_RETHROW_EXCEPTIONS),

        [Alias('ds')] [Switch]        $DoubleSpace,
        [Alias('ps')] [Switch]        $PreSpace,

        [Alias('o')]                  $Object,
        [Alias('rd')] [Int]           $MaxRecursionDepth = 3,

        [Alias('fw')] [Switch]        $ForceWrite

    )

    process {

        try {

            $MessageType         = [string]::IsNullOrEmpty($Type) ? $PSCmdlet.ParameterSetName : $Type
            $IgnoreMessageTypes  = $env:PS_STATUSMESSAGE_IGNORE_MESSAGE_TYPES | ConvertFrom-JSON
            $VerboseMessageTypes = $env:PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES | ConvertFrom-JSON
            $WriteVerboseTypes   = [System.Convert]::ToBoolean($env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES)

            if ( ($MessageType -in $VerboseMessageTypes -and $WriteVerboseTypes -eq $false -and $ForceWrite -eq $false) -or 
                 ($MessageType -in $IgnoreMessageTypes -and $ForceWrite -eq $false) ) 
            {
                # This message should not be written to the console.
            }
            else {

                $messageObject = [Hashtable]@{
                    Message              = $Message
                    Type                 = $MessageType
                    IncludeParameters    = $IncludeParameters.ToBool()
                    TimeStamps           = $TimeStamps.ToBool()
                    Labels               = $Labels.ToBool()
                    LabelTypes           = $env:PS_STATUSMESSAGE_LABEL_MESSAGE_TYPES | ConvertFrom-JSON
                    IndentationLevel     = $IndentationLevel
                    IndentationString    = $IndentationString
                    Banner               = $Banner.ToBool()
                    DoubleBanner         = $DoubleBanner.ToBool()
                    BannerString         = $BannerString
                    BannerLength         = $BannerLength
                    ColorBanners         = $ColorBanners.ToBool()
                    DoubleSpace          = $DoubleSpace.ToBool()
                    PreSpace             = $PreSpace.ToBool()
                    DebugObject          = $Object
                    MaxRecursionDepth    = $MaxRecursionDepth
                    MessagePrefix        = $null
                    MessageBanners       = $null
                    DebugObjectPrefix    = $null
                    InvocationSource     = Get-PSCallStack | Select-Object -Skip 2 -First 1 -ExpandProperty 'Command'
                    InvocationLine       = Get-PSCallStack | Select-Object -Skip 2 -First 1 -ExpandProperty 'ScriptLineNumber'
                    InvocationFile       = Get-PSCallStack | Select-Object -Skip 2 -First 1 -ExpandProperty 'ScriptName'
                    TargetFunctionName   = Get-PSCallStack | Select-Object -Skip 1 -First 1 -ExpandProperty 'Command'
                    TargetFunctionFile   = Get-PSCallStack | Select-Object -Skip 1 -First 1 -ExpandProperty 'ScriptName'
                    TargetFunctionParams = Get-PSCallStack | Select-Object -Skip 1 -First 1 -ExpandProperty 'InvocationInfo' |
                                                             Select-Object -ExpandProperty 'BoundParameters'
                }

                if ( $messageObject.Type -eq 'FunctionCall' ) {
                    $messageObject | Write-AutoGeneratedFunctionCallMessages | Out-Null
                }
                elseif ( $messageObject.Type -eq 'FunctionResult' ) {
                    $messageObject | Write-AutoGeneratedFunctionResultMessages | Out-Null
                }
                else {
                    $messageObject |
                        Set-AutoGeneratedInvocationMessage |
                        Set-AutoGeneratedExceptionMessage |
                        Set-StatusMessageColor |
                        Set-StatusMessagePrefix |
                        Set-StatusMessageBanners |
                        Write-StatusMessageToConsole |
                        Out-Null
                }

            }

        }
        catch {

            Write-ExceptionMessage -e $_

        }
        finally {

            if ( $messageObject.type -eq 'Exception' -and $RethrowException ) {
                if ( $Object -is [System.Management.Automation.ErrorRecord] ) {
                    throw $Object.Exception
                }
                else {
                    throw $Message
                }
            }

        }

    }
}
