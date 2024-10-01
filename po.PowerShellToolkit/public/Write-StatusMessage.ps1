function Write-StatusMessage {
    <#
    .SYNOPSIS
        Writes a formatted status message to the console.

    .DESCRIPTION
        Writes a formatted status message to the console.

    .PARAMETER Message
        REQUIRED. String. Alias: -m. The message to be written to the console.

    .PARAMETER Type
        OPTIONAL. String. Alias: -t. The type of message to write. Default value: 'Action'.

        The type determines several properties of the output, including the color, label and when the messages
        are supressed. The type of message can also be set using the following switches: -Header, -Process,
        -Action, -Information, Dbg, -Success, -Warning, -Failure, -Err -ExceptionError

        Message types of Header, Process, Information, and Debug are by default considered verbose and are only
        shown when the PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES is set to true. This list can be modified by updating
        the PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPESS environment variable. The value of this variable should be a
        JSON array of strings since environment variables can only store strings.
        Examples:
            $env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES  = $true
            $env:PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPESS = '["Header","Process","Debug","Information"]'

        By default, all messages are written using the Write-Host function. Writing to the other PowerShell
        output streams can be enabled by setting the PS_STATUSMESSAGE_USE_ALL_OUTPUT_STREAMS environment variable
        to true. The message types and associated streams are show in the table below.

            Type          Msg Color    Msg Header   Verbose  PS Write Function
            ------------  -----------  -----------  -------  -----------------
            Header        Magenta      -none-       Yes      Write-Verbose
            Process       Cyan         -none-       Yes      Write-Verbose
            Action        White        -none-       No       Write-host
            Information   DarkGray     -none-       Yes      Write-Verbose
            Debug         DarkGray     DEBUG        Yes      Write-Debug
            Success       DarkGreen    SUCCESS      No       Write-host
            Warning       DarkYellow   WARNING      No       Write-Warning
            Failure       DarkRed      FAILURE      No       Write-Error
            Error         Red          ERROR        No       Write-Error
            Exception     Red          EXCEPTION    No       Write-Error

            PowerShell Write-Functions:
                Write-Host     :: Write-Host streams are always written.
                Write-Output   :: not used for display by this function.
                Write-Warning  :: Controlled by $WarningPreference.
                Write-Error    :: Controlled by
                Write-Debug    :: Controlled by $DebugPreference: SilentlyContinue (hidden) or Continue (shown).
                Write-Verbose  :: Controlled by $VerbosePreference: SilentlyContinue (hidden) or Continue (shown).

                The Write-Functions use the standard user preference variables values to determin if the message
                should be displayed. Setting the preference to SilentlyContinue will hide the messages and
                setting the preference to Continue will show the messages.

    .PARAMETER Header
        OPTIONAL. Switch. Alias: -h. Switch alternative for the Header Type paramater. Message Color: Magenta.
        Header messages are only shown when the PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES environment variable is
        set to true. This can be changed by updating the PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPESS environment
        variable.

    .PARAMETER Process
        OPTIONAL. Switch. Alias: -p. Switch alternative for the Process Type paramater. Message Color: Cyan.
        Process messages are only shown when the PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES environment variable is
        set to true. This can be changed by updating the PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPESS environment
        variable.

    .PARAMETER Action
        OPTIONAL. Switch. Alias: -a. Switch alternative for the Action Type paramater. Message Color: Gray.
        Action is the default message type if no type is specified. Action messages are always shown.

    .PARAMETER Information
        OPTIONAL. Switch. Alias: -i. Switch alternative for the Information Type paramater. Message Color: DarkGray.
        Information messages are only shown when the PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES environment variable is
        set to true. This can be changed by updating the PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPESS environment
        variable.

    .PARAMETER Dgb
        OPTIONAL. Switch. Alias: -d. Switch alternative for the Debug Type paramater. Message Color: DarkGray.
        Debug messages are only shown when the PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES environment variable is
        set to true. This can be changed by updating the PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPESS environment
        variable.

    .PARAMETER Success
        OPTIONAL. Switch. Alias: -s. Switch alternative for the Success Type paramater. Message Color: Green.

    .PARAMETER Warning
        OPTIONAL. Switch. Alias: -w. Switch alternative for the Warning Type paramater. Message Color: Yellow.

    .PARAMETER Failure
        OPTIONAL. Switch. Alias: -f. Switch alternative for the Failure Type paramater. Message Color: Red.

    .PARAMETER Err
        OPTIONAL. Switch. Alias: -e. Switch alternative for the Error Type paramater. Message Color: Red.

    .PARAMETER Exception
        OPTIONAL. Switch. Alias: -x. Switch alternative for the Exception Type paramater. Message Color: Red.
        Assigning the Error object to the MessageObject parameter for this type of message will automatically
        generate an exception message based on the error details and append it to the message parameter.

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

    .PARAMETER Object
        OPTIONAL. Alias: -o. An object whose properties will be written to the console. The object is
        converted to a JSON object for display to the screen.

    .PARAMETER MaxRecursionDepth
        OPTIONAL. Integer. Alias: -rd. The maximum depth of recursion when converting the item specified by the
        object parameter to a JSON string. Default value: 3. The powreshell maxium value is 100.
        This value can be set using an environment variable.
            Example: $env:PS_STATUSMESSAGE_MAX_RECURSION_DEPTH = 10

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
        [ValidateSet('Header','Process','Action','Information','Debug','Success','Warning','Failure','Error','Exception')]
        [Alias('t')]  [String]         $Type,

        [Parameter(ParameterSetName = "Header")]
        [Alias('h')]  [Switch]         $Header,

        [Parameter(ParameterSetName = "Process")]
        [Alias('p')]  [Switch]         $Process,

        [Parameter(ParameterSetName = "Action")]
        [Alias('a')]  [Switch]         $Action,

        [Parameter(ParameterSetName = "Information")]
        [Alias('i')]  [Switch]         $Information,

        [Parameter(ParameterSetName = "Debug")]
        [Alias('d')]  [Switch]         $Dbg,

        [Parameter(ParameterSetName = "Success")]
        [Alias('s')]  [Switch]         $Success,

        [Parameter(ParameterSetName = "Warning")]
        [Alias('w')]  [Switch]         $Warning,

        [Parameter(ParameterSetName = "Failure")]
        [Alias('f')]  [Switch]         $Failure,

        [Parameter(ParameterSetName = "Error")]
        [Alias('e')]  [Switch]         $Err,

        [Parameter(ParameterSetName = "Exception")]
        [Alias('x')]  [Switch]         $Exception,

        [Alias('ts')] [Switch]         $TimeStamps = [System.Convert]::ToBoolean($env:PS_STATUSMESSAGE_TIMESTAMPS),
        [Alias('l')]  [Switch]         $Labels     = [System.Convert]::ToBoolean($env:PS_STATUSMESSAGE_LABELS),

        [Alias('il')] [Int]            $IndentationLevel = 0,
        [Alias('is')] [String]         $IndentationString = $env:PS_STATUSMESSAGE_INDENTATION_STRING,

        [Alias('b')]  [Switch]         $Banner,
        [Alias('bb')] [Switch]         $DoubleBanner,
        [Alias('bs')] [String]         $BannerString = $env:PS_STATUSMESSAGE_BANNER_STRING,
        [Alias('bl')] [Int]            $BannerLength = [System.Convert]::ToInt32($env:PS_STATUSMESSAGE_BANNER_LENGTH),
        [Alias('cb')] [Switch]         $ColorBanners = [System.Convert]::ToBoolean($env:PS_STATUSMESSAGE_COLOR_BANNERS),

        [Alias('ds')] [Switch]         $DoubleSpace,
        [Alias('ps')] [Switch]         $PreSpace,

        [Alias('o')]                   $Object,
        [Alias('rd')] [Int]            $MaxRecursionDepth = 3

    )

    process {

        try {

            $messageObject = [Hashtable]@{
                Message             = $Message
                Type                = [string]::IsNullOrEmpty($Type) ? $PSCmdlet.ParameterSetName : $Type
                TimeStamps          = $TimeStamps.ToBool()
                Labels              = $Labels.ToBool()
                LabelTypes          = $env:PS_STATUSMESSAGE_LABEL_MESSAGE_TYPES | ConvertFrom-JSON
                IndentationLevel    = $IndentationLevel
                IndentationString   = $IndentationString
                Banner              = $Banner.ToBool()
                DoubleBanner        = $DoubleBanner.ToBool()
                BannerString        = $BannerString
                BannerLength        = $BannerLength
                ColorBanners        = $ColorBanners.ToBool()
                DoubleSpace         = $DoubleSpace.ToBool()
                PreSpace            = $PreSpace.ToBool()
                DebugObject         = $Object
                MaxRecursionDepth   = $MaxRecursionDepth
                MessagePrefix       = $null
                MessageBanners      = $null
                DebugObjectPrefix   = $null
                VerboseMessageTypes = $env:PS_STATUSMESSAGE_VERBOSE_MESSAGE_TYPES | ConvertFrom-JSON
                WriteVerboseTypes   = [System.Convert]::ToBoolean($env:PS_STATUSMESSAGE_SHOW_VERBOSE_MESSAGES)
                InvocationSource    = Get-PSCallStack | Select-Object -Skip 1 -First 1 -ExpandProperty 'Command'
            }

            $messageObject |
                Test-MessageTypeShouldBeWritten |
                Set-AutoGeneratedExceptionMessage |
                Set-StatusMessageColor |
                Set-StatusMessagePrefix |
                Set-StatusMessageBanners |
                Write-StatusMessageToConsole |
                Out-Null

        }
        catch {

            if ($_.Exception.Message -ne "MessageTypeShouldNotBeWritten") {
                Write-ExceptionMessage -e $_
            }

        }

    }
}
