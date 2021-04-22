# The nym-mixnode installer for 0.10.0 testnet

##### * An ***unofficial*** **nym-mixnode** installer.

This script installs all dependencies, downloads Nym-mixnode binaries, promts user for the input for the mixnode configuration
, creates a systemd.service file based on the user input, enables ufw and nym-mixnode.service and then launches the node.
Nym-mixnode is being launched by systemctl with a newly created user *nym* from */home/nym/* directory. 

For the current testnet, it also has new features including *sign* and *claim*. 

Official Nym repos can be found here: https://github.com/nymtech/
## Compatible systems & recommendations

* It has been **tested** on **Debian 10** and **Ubuntu 20.04**
* Make sure to `apt update` on a fresh machine and also that **git** is installed. 

* I would highly **recommend** to **run** this script on a **fresh Debian 10** machine on **VPS**. 


* It currently **won't** run on on **non-Debian based distros** unless you edit the script for your distro package manager. 

* This installer **will not** work with cloud providers such as Google Cloud and if you run this from your home network behind NAT. 
This function will be added later in the upcoming future. Reason is you need to add **--host LOCAL_IP --announce-host PUBLIC_IP** during the **init phase**
In this case you can still use it to create a systemd.service file for a better control of your node and checking its status.

* this script needs to be run as **sudo** or **root**, but then **nym-mixnode** will be run with a user *nym*


* MAKE SURE TO SEE USAGE HERE IN THIS README or use --help along with the script!

* Beginners, please use the *installation with git*. Do not tunnel from a tunnel to the same tunnel, please...:)


## one-liner full installation
Copy the whole command into your terminal. Assuming you have the ssh keys set up and you are ready to connect to the server

**NOTE:**  **Windows** users connecting with [Putty](https://www.putty.org/) - **do not follow** these instructions. You would be connecting from your server back to the same server, which makes no sense and it won't work. Read the next section - download the installer from Github.

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

**NOTE:** On fresh Debian 10 server *sudo* is not installed by default or when logged in as **root** user, you do not need to use *sudo*. Simply run the commands without sudo if you're root.

``` 
git clone https://github.com/gyrusdentatus/nym_autoinstall 
```

``` 
cd nym_autoinstall 
```

Make the installer executable

```
chmod +x nym_install.sh
```

If you want to proceed to the full install, config and launch then

``` 
sudo ./nym_install.sh -i 
```

To see full help/usage of the installer

``` 
sudo ./nym_install.sh --help 
```


## Usage

```
USAGE:
    ./nym_install.sh [FLAGS] 
FLAGS:
    -t  --testnet           Display testnet help and steps
    -i  --install           Full installation and setup
    -c  --config            Run only the init command without installation
    -r, --run               Start the node without installation
    -m  --claim             Display the claim output of your node
    -g  --sign              Sign your node
    -h, --help              Prints help information
    -V, --version           Prints version information
    -s  --status            Prints status of the running node
    -f  --firewall          Firewall setup
    -p  --print             Create nym-mixnode.service for systemd
    -l  --print-local       Create nym-mixnode.service for systemd LOCALLY in the current directory
    -u  --update            Update the node to the latest release and choose an address for the incetives.
```

## Full build

### *The guide is outdated but I guess the only thing you need to change is the git checkout tags part to the current version*

If you would like to build the whole Nym platform from source, see my guide [here](https://gist.github.com/gyrusdentatus/e81658af3086c8d833720af53d5b2c3d).

Depending on your skills with Linux, you can skip to **Section 3**

Platform build instructions are available on [official Nym docs](https://nymtech.net/docs). Go there especially if you have issues with bonding and if this script fails for whatever reason. 

## Nym-mixnode setup chat

If you need any help, join our chat on Telegram - [Nym mixnode setup chat](https://t.me/nymchan_help_chat). 
