
# nym_autoinstall 1.1 (2020-26-06)

## The installer and launcher for Nym mixnode /// work in progress 
## This is an unofficial community script, created by myself, to automate this installation on multiple machines.  
---
### This is an unofficial nym-mixnode installer, which downloads, configures
### and runs the Nym mixnode in less than 1 minute.
### It creates a nym user which runs the node with a little help of
### a systemd. It automates even the systemd.service creation, so
### everytime you change your node config, simply just do it with this script
### to make sure your Nym-mixnode is running and mixin' packets!
### -------------------------------------------------------------------------
### All credits go to the Nym team, creators of BASH, other FOSS used
### and some random people on stackoverflow.com.
### There might be some bugs in this script ... !
### So you'd better run this piece with caution.
### I will be not responsible if you fuck up your own machine with this.
### Brace yourself ...
#
### A Change Is Gonna Come && Give Peace a Chance && Power to the People |
### turn_on_tune_in_drop_out

## Requirements: run all commands as root/w sudo obviously

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
