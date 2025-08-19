function Invoke-HttpRequest {
    <#
    .DESCRIPTION
        Gets the result of an HTTP request.

    .OUTPUTS
        A PSCustomObject with the following properties:
           - uri
           - host
           - requestHeaders
           - success
           - statusCode
           - statusDescription
           - responseUri
           - value
           - links
           - images
           - responseHeaders
           - message
           - startTime
           - duration

    .PARAMETER URL
        REQUIRED. String. Alias: -u. A complete URL, including the Protocol, Server and Path.
        Examples: http://www.cloudflare.com/home

    .PARAMETER ServerName
        REQUIRED. String. Alias: -s. The server name or IP address to use for the request. This is the physical
        address that is used as part of the URL and used for DNS resolution.
        Examples: www.cloudflare.com OR 1.1.1.1

    .PARAMETER HostName
        OPTIONAL. String. Alias: -h. The hostname. The name of the host to use for the request, if it is
        different from the server name. If provided this name is used as the Host header for the request.
        Use this parameter when you wish to test directly against a server without going through full DNS
        resolution / network path. For example, you can test the local web site on a server that normally
        responds to 'www.mysite.com' by specifying a servername of 'localhost' and a host header of
        'www.mysite.com', bypassing the DNS resolution and network path (firewalls, WAFs, etc.).

    .PARAMETER Path
        OPTIONAL. String. Alias: -p. The path of the request. The path should start with '/'/ Example: /page.html
        Default: / (root of the server)

    .PARAMETER Protocol
        OPTIONAL. String. Alias: -o. The protocol. Accepted Values: HTTP or HTTPS.
        Default: HTTP

    .PARAMETER UseBasicParsing
        OPTIONAL. Switch. Alias: -b. Use a basic, non-DOM parsing model for the content. This is more performant
        but can make the results harder to parse.

        NOTE: This parameter has been deprecated. Beginning with PowerShell 6.0.0, all Web requests use basic 
              parsing only. This parameter is included for backwards compatibility only and any use of it has 
              no effect on the operation of the function.

    .PARAMETER AuthorizationToken
        OPTIONAL. String. Alias: -t. The authorization token to pass as part of the request. This will be used
        by the "Authorization:" header as a bearer token. Example: "Authorization: Bearer <passed token>"

    .PARAMETER JSON
        OPTIONAL. Switch. Alias: -j. Adds the "accept: application/json" header to type the result as JSON.

    .PARAMETER Silent
        OPTIONAL. Switch. Alias: -l, -q, -quiet. Do not display or any log events. This overrides the logging 
        preferences set at the environment level.

    .PARAMETER DebugMessagesOnly
        OPTIONAL. Switch. Alias: -d. Sets the type of all success and error messages for any http result to the 
        'debug' message type. This does not affect errors cause by events other than the HTTP request.

    .EXAMPLE
        Invoke-HttpRequest -o 'https' -h 'www.cloudflare.com'

    .EXAMPLE
        Invoke-HttpRequest -o 'https' -h 'github.com' -p '/seabopo'
    #>
    [OutputType([System.Collections.Specialized.OrderedDictionary])]
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName="URI", Mandatory)]
        [String] [Alias('u')] $Url,
        
        [Parameter(ParameterSetName="PSHP",Mandatory)]
        [String] [Alias('s')] $ServerName,
        
        [Parameter(ParameterSetName="PSHP")]
        [String] [Alias('h')] $HostName = $null,
        
        [Parameter(ParameterSetName="PSHP")]
        [String] [Alias('p')] $Path = '/',
        
        [Parameter(ParameterSetName="PSHP")]
        [ValidateSet("http","https")] 
        [String] [Alias('o')] $Protocol = 'http',
        
        [Parameter()]
        [Switch] [Alias('b')] $UseBasicParsing,

        [Parameter()]
        [String] [Alias('t')] $AuthorizationToken,

        [Parameter()]
        [Switch] [Alias('j')] $JSON,
        
        [Parameter()]
        [Switch] [Alias('l','q','quiet')] $Silent,

        [Parameter()]
        [Switch] [Alias('d')] $DebugMessagesOnly
    )

    process {

        try {

            [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

            Write-Msg -FunctionCall -IncludeParameters

            $r = [ordered]@{
                uri               = $null
                host              = $null
                requestHeaders    = $null
                success           = $true
                statusCode        = $null
                statusDescription = $null
                responseUri       = $null
                value             = $null
                links             = $null
                images            = $null
                responseHeaders   = $null
                message           = $null
                startTime         = $null
                duration          = $null
            }

            if ( $PSCmdlet.ParameterSetName -eq 'PSHP' ) {
                
                if ( -not $Path.StartsWith('/') ) { $Path = '/' + $Path }
                
                $r.uri            = '{0}://{1}{2}' -f $Protocol, $ServerName, $Path
                $r.host           = $([String]::IsNullOrEmpty($HostName) ? $ServerName : $HostName)
                $r.requestHeaders = @{ host = $([String]::IsNullOrEmpty($HostName) ? $ServerName : $HostName) }

            }
            else {
                $r.uri = $url
            }

            if ( -not [String]::IsNullOrEmpty($AuthorizationToken) ) {
                $r.requestHeaders += @{ Authorization = $('Bearer {0}' -f $AuthorizationToken) }
            }

            if ( $JSON ) {
                $r.requestHeaders += @{ Accept = 'application/json' }
            }

            if ( -not $Silent ) { Write-Msg -p -ps -m $( 'Getting results for URI: {0} ...' -f $r.uri ) }

            $r.startTime = Get-Date

            try {
                
                if ( [String]::IsNullOrEmpty($r.requestHeaders) ) {
                    $result = Invoke-WebRequest -Uri $r.uri
                } else {
                    $result = Invoke-WebRequest -Uri $r.uri -Headers $r.requestHeaders
                }

                $r.duration          = [Math]::Round((New-TimeSpan -Start $r.startTime -End (Get-Date)).TotalSeconds,0).ToString()
                $r.value             = $result.Content
                $r.responseHeaders   = $result.Headers
                $r.links             = $result.Links
                $r.images            = $result.Images
                $r.statusCode        = $result.StatusCode
                $r.statusDescription = $result.StatusDescription
                $r.responseUri       = $result.BaseResponse.RequestMessage.RequestUri.AbsoluteUri
                $r.message           = $( 'Result: HTTP {0} in {1} second(s) from {2}' -f
                                          $r.statusCode, $r.duration,$r.responseUri )
            }
            catch {
                $r.duration          = [Math]::Round((New-TimeSpan -Start $r.startTime -End (Get-Date)).TotalSeconds,0).ToString()
                $r.success           = $false
                $r.message           = $_.Exception.Message
                $r.statusCode        = $_.Exception.Response.StatusCode.value__
                $r.statusDescription = $_.Exception.Response.ReasonPhrase
                $r.responseUri       = $_.TargetObject.RequestUri.AbsoluteUri
                
            }
            
            if ( -not $Silent ) {
                if ( $DebugMessagesOnly ) {
                    Write-Msg -d -il 1 -m $r.message
                }
                elseif ( $r.success ) {
                    Write-Msg -s -il 1 -m $r.message
                }
                else {
                    Write-Msg -e -il 1 -m $r.message
                }
            }

        }
        catch {
            $r.success = $false
            $r.message = $_.Exception.Message
            if ( -not $Silent ) { Write-Msg -x -o $_ }
        }

        return $r

    }

}
