# Factorio-Server

This repository contains a bash script to automate the process of updating a headless Factorio server running on Linux.

## update-game.sh

`update-game.sh` is a bash script that simplifies the process of updating your Factorio server. It automatically downloads the latest version of Factorio, extracts it, moves it to the correct location, and copies over your server configuration files, game saves, and mods from the previous installation. Finally, it reloads the systemd manager configuration and restarts the Factorio service.

### Usage

1. Copy the script to your server.
2. Make the script executable:
```bash
chmod +x update_factorio.sh
```
3. Run the script with escalated privileges (necessary for the systemctl commands inside):
```bash
sudo ./update_factorio.sh
```
4. Enjoy
### Prerequisites
The script requires wget and systemd. Most Linux distributions include these by default.

### Disclaimer
This script modifies system files and requires root privileges to run. Please use it at your own risk and ensure you understand what the script does before running it.

## Why did I make this?
I play [Factorio](https://factorio.com/) a ton because it is a [fantastic game](https://steamcommunity.com/profiles/76561197970691968/recommended/427520/). I started using an old computer as a game server to save on hosting costs and to challenge myself with some basic networking tasks. I modeled my config off of this [gist](https://gist.github.com/othyn/e1287fd937c1e267cdbcef07227ed48c). I'm making this tiny collection of files a public repo because I haven't done that since my coding bootcamp, and my github profile looks quite abandoned.