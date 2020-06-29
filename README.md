# The nym-mixnode installer 0.7.0

##### * An ***unofficial*** **nym-mixnode** installer.

This script installs all dependencies, downloads Nym-mixnode binaries, promts user for the input for the mixnode configuration
, creates a systemd.service file based on the user input, enables ufw and nym-mixnode.service and then launches the node.
Nym-mixnode is being launched by systemctl with a newly created user *nym* from */home/nym/* directory. 

Official Nym repos can be found here: https://github.com/nymtech/
## Compatible systems & recommendations

* It has been **tested** on **Debian 10**. Ubuntu should be compatible as well. 

* I would highly **recommend** to **run** this script on a **fresh Debian 10** machine on **VPS**. 


* It currently **won't** run on on **non-Debian based distros** unless you edit the script for your distro package manager. 

* Additional configuration would be needed on cloud providers such as Google Cloud and if you run this from your home network behind NAT. 
This function will be added later in the upcoming future. 

* this script needs to be run as **sudo** or **root**, but then **nym-mixnode** will be run with a user *nym*



## one-liner full installation
Copy the whole command into your terminal. Assuming you have the ssh keys set up and you are ready to connect to the server

If you are not sure how to do that and you are using MacOS 10.13+ check Section 2 in my [guide](https://gist.github.com/gyrusdentatus/e81658af3086c8d833720af53d5b2c3d).

--------------------

on fresh Debian 10 as root:

``` 
ssh root@x.x.x.x -t 'apt update -y && apt install git -y && git clone https://github.com/gyrusdentatus/nym_autoinstall && cd nym_autoinstall && bash nym_install.sh -i'
```
---
As a sudo user: 
```
ssh username@x.x.x.x -t 'sudo apt update -y && sudo apt install git -y && git clone https://github.com/gyrusdentatus/nym_autoinstall && cd nym_autoinstall && sudo bash nym_install.sh -i'
```
----

Then just **follow the instructions** and your mixnode will run within 2 minutes, or even 30 seconds if your server is fast !

## Installation with git

``` 
git clone https://github.com/gyrusdentatus/nym_autoinstall 
```

``` 
cd nym_autoinstall 
```

``` 
sudo bash ./nym_install.sh --help 
```

or if you want to proceed to the full install, config and launch then

``` 
sudo bash ./nym_install.sh -i 
```
## Usage

```
USAGE:
    ./nym_install.sh [FLAGS] 
FLAGS:
    -i  --install           Full installation and setup
    -c  --config            Run only the init command without installation
    -r, --run               Start the node without installation
    -h, --help              Prints help information
    -V, --version           Prints version information
    -s  --status            Prints status of the running node
    -f  --firewall          Firewall setup
    -p  --print             Create nym-mixnode.service for systemd
    -l  --print-local       Create nym-mixnode.service for systemd LOCALLY in the current directory
```

## Full build

If you would like to build the whole Nym platform from source, see my guide [here](https://gist.github.com/gyrusdentatus/e81658af3086c8d833720af53d5b2c3d).

Depending on your skills with Linux, you can skip to **Section 3**

Platform build instructions are available on [official Nym docs](https://nymtech.net/docs).

## Nym-mixnode setup chat

If you need any help, join our chat on Telegram - [Nym mixnode setup chat](https://t.me/nymchan_help_chat). 
