
# nym_autoinstall 1.0 (2020-21-06)

## The installer and launcher for Nym mixnode /// work in progress 
## This is an unofficial community script, created by myself, to automate this installation on multiple machines.  
---

### This simple script installs and let you configure and run nym-mixnode all in one go. Tested on Debian 10. 
### This is an unofficial community script, created by myself
### Make sure you have all basic packages before running this and ufw rules set to allow in/out traffic on port 1789 
### Since the script creates a new user nym you need to run this as root/with sudo
---
### Requirements: run all commands as root/w sudo obviously

```
apt install curl ufw sudo git pkg-config build-essential libssl-dev 

```

### set up the ufw

```
ufw allow 22/tcp && ufw allow 1789/tcp 

```
```
ufw enable

```

### Download the script

```
git clone https://github.com/gyrusdentatus/nym_autoinstall

```

```
cd nym_autoinstall

```

```
./nym_autoinstall --help

```
---
OR with cURL

```
curl --proto '=https' -sSfk https://hacknito.eu > nym_autoinstall.sh 
sudo bash ./nym_autoinstall.sh --help

```
---

```

USAGE:
    ./nym_autoinstall.sh [FLAGS] [OPTIONS]

FLAGS:
    -i --install            Full installation and setup
    -c --config             Run only the init command without installation                    
    -r, --run               Start the node without installation
    -h, --help              Prints help information
    -V, --version           Prints version information

```

feel free to have a chat here on Telegram https://t.me/nymchan_help_chat @gyrusdentatus. 
Also make sure you read the official docs https://nymtech.net/docs/ and join the telegram chat and keybase for more info! 
#### HAPPY MIXXIN
