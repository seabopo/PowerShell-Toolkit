function Set-StatusMessageColor {
    <#
    .DESCRIPTION
        Sets the color of the status message based on the message type.
    #>
    [OutputType([HashTable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [HashTable] $MessageObject )

    process {

        try {

            try {
                $test = [System.Convert]::ToBoolean($MessageObject.TypeTestResult)
            } catch [FormatException] {
                $test = $false
            }

            $MessageObject.MessageColor = switch ( $MessageObject.Type ) {
                                              "SuccessOrFailure" { $test ? "DarkGreen" : "DarkRed"    ; break }
                                              "SuccessOrWarning" { $test ? "DarkGreen" : "DarkYellow" ; break }
                                              "ActionOrFailure"  { $test ? "Gray"      : "DarkRed"    ; break }
                                              "ActionOrWarning"  { $test ? "Gray"      : "DarkYellow" ; break }
                                              "Header"           { "Magenta"                          ; break }
                                              "Process"          { "Cyan"                             ; break }
                                              "Action"           { "Gray"                             ; break }
                                              "Information"      { "DarkGray"                         ; break }
                                              "Debug"            { "DarkGray"                         ; break }
                                              "Success"          { "DarkGreen"                        ; break }
                                              "Warning"          { "DarkYellow"                       ; break }
                                              "Failure"          { "DarkRed"                          ; break }
                                              "Error"            { "Red"                              ; break }
                                              "Exception"        { "Red"                              ; break }
                                              "InvocationSource" { "DarkGray"                         ; break }
                                              default            { "Gray"                             ; break }
                                        }

            Write-Output $MessageObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
