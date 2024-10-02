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

            $MessageObject.MessageColor = switch ( $MessageObject.Type )
                                        {
                                            "Header"      { "Magenta"    ; break }
                                            "Process"     { "Cyan"       ; break }
                                            "Action"      { "Gray"       ; break }
                                            "Information" { "DarkGray"   ; break }
                                            "Debug"       { "DarkGray"   ; break }
                                            "Success"     { "DarkGreen"  ; break }
                                            "Warning"     { "DarkYellow" ; break }
                                            "Failure"     { "DarkRed"    ; break }
                                            "Error"       { "Red"        ; break }
                                            "Exception"   { "Red"        ; break }
                                            default       { "Gray"       ; break }
                                        }

            Write-Output $MessageObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}

# write-host 'Some Test Text in DarkBlue   ' -ForegroundColor DarkBlue
# write-host 'Some Test Text in White      ' -ForegroundColor White
