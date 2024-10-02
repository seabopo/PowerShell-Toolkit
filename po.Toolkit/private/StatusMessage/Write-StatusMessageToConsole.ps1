function Write-StatusMessageToConsole {
    <#
    .DESCRIPTION
        Writes a formatted status message to the console.
    #>
    [OutputType([HashTable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [HashTable] $MessageObject )

    process {

        try {

            $bannerColor = ( $MessageObject.ColorBanners ) ? @{ ForegroundColor = $MessageObject.MessageColor } :
                                                             @{ ForegroundColor = 'White' }

            if ( $MessageObject.PreSpace ) { Write-Host '' }

            if ( $MessageObject.MessageBanners ) { Write-Host $MessageObject.MessageBanners @bannerColor }

            if ( $null -eq $MessageObject.DebugObject ) {

                $MessageObject.Message = $MessageObject.MessagePrefix + $MessageObject.Message
                Write-Host $MessageObject.Message -ForegroundColor $MessageObject.MessageColor

            }
            else {

                $convertParams = @{
                    Object          = $MessageObject.DebugObject
                    MaxDepth        = $MessageObject.MaxRecursionDepth
                    MultiLinePrefix = $MessageObject.DebugObjectPrefix
                }
                $value, $multiLine = ConvertTo-MessageString @convertParams -r

                if ( $multiLine ) {
                    $MessageObject.Message = $MessageObject.MessagePrefix + $MessageObject.Message +
                                             '[' + $MessageObject.DebugObject.GetType().Name + ']' +
                                             $value
                    Write-Host $MessageObject.Message -ForegroundColor $MessageObject.MessageColor
                }
                else {
                    $MessageObject.Message = $MessageObject.MessagePrefix + $MessageObject.Message + $value
                    Write-Host $MessageObject.Message -ForegroundColor $MessageObject.MessageColor
                }

            }

            if ( $MessageObject.MessageBanners ) { Write-Host $MessageObject.MessageBanners @bannerColor }

            if ( $MessageObject.DoubleSpace ) { Write-Host '' }

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
