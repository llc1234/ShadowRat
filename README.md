# PowerShell Discord Shell Executor
This script enables a simple Discord bot that can execute shell commands on the host system. The bot continuously checks for new messages in a specified channel and executes commands prefixed with <shell>.

<h1>Prerequisites</h1>
PowerShell 5.1 or later
Discord Bot Token
Discord channel URL


<h1>Configuration</h1>
Before running the script, make sure to set the following variables:

```powershell
$url = "<DISCORD_CHANNEL_URL>"
$discordToken = "<DISCORD_BOT_TOKEN>"
$master_ID = "<DISCORD_AUTHOR_ID>"
```

<h1>Usage</h1>
Replace <DISCORD_CHANNEL_URL> with the URL of the Discord channel where you want the bot to listen for commands.
Replace <DISCORD_BOT_TOKEN> with your actual Discord bot token.
Run the script, and the bot will start monitoring the specified Discord channel for commands.

<h1>How it works</h1>
The script uses the Invoke-WebRequest cmdlet to retrieve the latest message from the specified Discord channel.
If the message content starts with shell, the script extracts the shell command from the message.
It then attempts to execute the shell command using Invoke-Expression.
The script captures the command output and constructs a multipart/form-data request to send the output back to the Discord channel.
If an error occurs during command execution, the script sends an error message to the Discord channel.

<h1>Note</h1>
Use this script responsibly and be cautious about the security implications of allowing remote execution of commands.
Ensure that the Discord bot has the necessary permissions to read messages, send messages, and manage webhooks in the specified channel.


<h1>Disclaimer:</h1>
This script is for educational purposes only, and llc1234 is not responsible for any misuse or damage caused by its use.
