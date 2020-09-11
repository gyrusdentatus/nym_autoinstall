# The nym-mixnode installer 0.8.0

##### * An ***unofficial*** **nym-mixnode** installer.

This script installs all dependencies, downloads Nym-mixnode binaries, promts user for the input for the mixnode configuration
, creates a systemd.service file based on the user input, enables ufw and nym-mixnode.service and then launches the node.
Nym-mixnode is being launched by systemctl with a newly created user *nym* from */home/nym/* directory. 

Official Nym repos can be found here: https://github.com/nymtech/
## Compatible systems & recommendations

* It has been **tested** on **Debian 10**. 
* There are **permission issues** on **Ubuntu 18.04** with user Nym, **not being able to create spinhx keys** for some weird N0-0buntu reason.  

* I would highly **recommend** to **run** this script on a **fresh Debian 10** machine on **VPS**. 


* It currently **won't** run on on **non-Debian based distros** unless you edit the script for your distro package manager. 

* This installer **will not** work with cloud providers such as Google Cloud and if you run this from your home network behind NAT. 
This function will be added later in the upcoming future. Reason is you need to add **--host LOCAL_IP --announce-host PUBLIC_IP** during the **init phase**
In this case you can still use it to create a systemd.service file for a better control of your node and checking its status.

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

### *The guide is outdated but I guess the only thing you need to change is the git checkout tags part to the current version*

If you would like to build the whole Nym platform from source, see my guide [here](https://gist.github.com/gyrusdentatus/e81658af3086c8d833720af53d5b2c3d).

Depending on your skills with Linux, you can skip to **Section 3**

Platform build instructions are available on [official Nym docs](https://nymtech.net/docs).

## Nym-mixnode setup chat

If you need any help, join our chat on Telegram - [Nym mixnode setup chat](https://t.me/nymchan_help_chat). 
