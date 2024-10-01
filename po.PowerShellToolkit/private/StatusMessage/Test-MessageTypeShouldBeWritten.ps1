function Test-MessageTypeShouldBeWritten {
    <#
    .DESCRIPTION
        Determines if the message type should be written and aborts the pipeline if it should not.
    #>
    [OutputType([HashTable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [HashTable] $MessageObject )

    process {

        if ( ( $MessageObject.WriteVerboseTypes -eq $false ) -and
             ( $MessageObject.Type -in $MessageObject.VerboseMessageTypes ) )
        {
            Throw "MessageTypeShouldNotBeWritten"
        }

        Write-Output $MessageObject

    }
}
