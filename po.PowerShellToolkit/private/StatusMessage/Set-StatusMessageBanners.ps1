function Set-StatusMessageBanners {
    <#
    .DESCRIPTION
        Adds a single or double banner to a status message.
    #>
    [OutputType([HashTable])]
    [CmdletBinding()]
    param ( [Parameter(Mandatory,ValueFromPipeline)] [HashTable] $MessageObject )

    process {

        try {

            if ( $MessageObject.Banner -or $MessageObject.DoubleBanner ) {

                $multiplier = [math]::Ceiling($MessageObject.BannerLength / $MessageObject.BannerString.Length)

                $bannerLine = ($MessageObject.BannerString * $multiplier).Substring(0, $MessageObject.BannerLength)

                if ( $MessageObject.Banner ) {
                    $MessageObject.MessageBanners = $bannerLine
                }
                else {
                    $MessageObject.MessageBanners = $bannerLine + [System.Environment]::NewLine + $bannerLine
                }

            }

            Write-Output $MessageObject

        }
        catch {

            Write-ExceptionMessage -e $_

        }

    }
}
