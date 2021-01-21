#!/bin/bash
############################################################################
## This is an unofficial nym-mixnode installer, which downloads, configures
## and runs the Nym mixnode in less than 1 minute.
## It creates a nym user which runs the node with a little help of
## a systemd. It automates even the systemd.service creation, so
## everytime you change your node config, simply just do it with this script
## to make sure your Nym-mixnode is running and mixin' packets!
## -------------------------------------------------------------------------
## All credits go to the Nym team, creators of BASH, other FOSS used
## and some random people on stackoverflow.com.
## There might be some bugs in this script ... !
## So you'd better run this piece with caution.
## I will be not responsible if you fuck up your own machine with this.
##
## turn_on_tune_in_drop_out
############################################################################


function display_usage() {
	#printf "%b\n\n\n" "${WHITE}This script must be run with super-user privileges."
	#echo -e "\nUsage:\n__g5_token5eefd24a11c4a [arguments] \n"


      cat 1>&2 <<EOF
nym_install.sh 0.9.1 (2020-25-11)
The installer and launcher for Nym mixnode

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
    -u  --update            Update the node to the latest release and choose an address for the incetives.
EOF
}


## Colours variables for the installation script
RED='\033[1;91m' # WARNINGS
YELLOW='\033[1;93m' # HIGHLIGHTS
WHITE='\033[1;97m' # LARGER FONT
LBLUE='\033[1;96m' # HIGHLIGHTS / NUMBERS ...
LGREEN='\033[1;92m' # SUCCESS
NOCOLOR='\033[0m' # DEFAULT FONT

## required packages list
install_essentials='curl ufw sudo git pkg-config build-essential libssl-dev'
## Checks if all required packages are installed
## If not then it installs them with apt-get
if
   printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
   printf "%b\n\n\n" "${WHITE} Checking requirements ..."
   dpkg-query -l 'curl' 'ufw' 'sudo' 'git' 'pkg-config' 'build-essential' 'libssl-dev' > /dev/null 2>&1
  then
   printf "%b\n\n\n" "${WHITE} You have all the required packages for this installation ..."
   printf "%b\n\n\n" "${LGREEN} Continuing ..."
   printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
  else
   printf "%b\n\n\n" "${WHITE} Some required packages for this script are not installed"
   printf "%b\n\n\n" "${WHITE} Installing them for you"
   apt-get update > /dev/null 2>&1 && apt-get install ${install_essentials} -y > /dev/null 2>&1
   printf "%b\n\n\n" "${WHITE} Now you have all the required packages for this installation ..."
   printf "%b\n\n\n" "${LGREEN} Continuing ... "
   printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
fi





#while true; do
#printf "${RED}LOVE\n\n${YELLOW}IS\n\n${LBLUE}ALL\n\n${WHITE}YOU\n\n${LGREEN}\nNEED\n\n ${RED}========${YELLOW}========${LBLUE}========${WHITE}========${LGREEN}========\n\n"
#sleep 1
#done


## Prints the Nym banner to stdout from hex
printf "%b\n" "0a2020202020205f205f5f20205f2020205f205f205f5f205f5f5f0a20202020207c20275f205c7c207c207c207c20275f205c205f205c0a20202020207c207c207c207c207c5f7c207c207c207c207c207c207c0a20202020207c5f7c207c5f7c5c5f5f2c207c5f7c207c5f7c207c5f7c0a2020202020202020202020207c5f5f5f2f0a0a20202020202020202020202020286d69786e6f6465202d2076657273696f6e20302e392e3129" | xxd -p -r

## Checks if essential packages are installed
## if not then it installs them
#dpkg-query -l 'curl' 'ufw' 'sudo' 'git' 'pkg-config' 'build-essential' 'libssl-dev' 'asdasd' > /dev/null 2>&1 || apt
# creates a user nym with home directory
function nym_usercreation() {
  printf "%b\n\n\n"
  printf "%b\n\n\n" "${YELLOW} Creating ${WHITE} nym user\n\n"
  if [ ! -d /home/nym ]
  then
    useradd -U -m -s /sbin/nologin nym
    printf "%b\n\n\n" "${WHITE} User ${YELLOW} nym ${LGREEN} created ${WHITE} with a home directory at ${YELLOW} /home/nym/"

  else
    printf "%b\n\n\n" "${WHITE} Something went ${RED} wrong ${WHITE} and the user ${YELLOW} nym ${WHITE}was ${RED} not created."

  fi
}

## Checks if nym user exists and then download the latest nym-mixnode binaries to nym home directory
function nym_download() {
  VERSION=$(curl https://github.com/nymtech/nym/releases/latest --cacert /etc/ssl/certs/ca-certificates.crt 2>/dev/null | egrep -o "[0-9|\.]{5}(-\w+)?")
  URL="https://github.com/nymtech/nym/releases/download/v$VERSION/nym-mixnode_linux_x86_64"
 if
   cat /etc/passwd | grep nym > /dev/null 2>&1
 then
    printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
    printf "%b\n\n\n" "${YELLOW} Downloading ${WHITE} nym-mixnode binaries for the nym user ..."
    cd /home/nym && curl -L -s "$URL" -o "nym-mixnode_linux_x86_64" --cacert /etc/ssl/certs/ca-certificates.crt && echo "Fetching the latest version"
    printf "%b\n\n\n"
    printf "%b\n\n\n" "${WHITE} nym-mixnode binaries ${LGREEN} successfully downloaded ${WHITE}!"
 else
    printf "%b\n\n\n"
    printf "%b\n\n\n" "${WHITE} Download ${RED} failed..."
 fi
}


## checks for the binaries and then makes them executable
function nym_chmod() {

 if ls -la /home/nym/ | grep nym-mixnode_linux_x86_64 > /dev/null 2>&1
 then
   printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
   printf "%b\n\n\n" "${WHITE} Making the nym binary ${YELLOW} executable ..."
   chmod 755 /home/nym/nym-mixnode_linux_x86_64
   printf "%b\n\n\n" "${LGREEN} Successfully ${WHITE} made the file ${YELLOW} executable !"
 else
   printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
   printf "%b\n\n\n" "${WHITE} Something went ${RED} wrong, wrong path..?"
 fi
}

## change ownerships of all files within nym home directory / they were downloaded as root so now we return them back to nym
function nym_chown() {
 chown -R nym:nym /home/nym/
 printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
 printf "%b\n\n\n" "${WHITE} Changed ownership of all conentes in ${YELLOW}/home/nym/ ${WHITE} to ${YELLOW}nym:nym"
}

## Get server ipv4
#ip_addr=`curl -sS v4.icanhazip.com`



## Check if ufw is enabled or not and allows 1789/tcp and 22/tcp
function nym_ufw {
printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
printf "%b\n\n\n" "${WHITE} Setting up the ${YELLOW} firewall ${WHITE}: "
ufw status | grep -i in && inactive="1" || is_active="1" > /dev/null 2>&1


if [ "${inactive}" == 1 ]
then
    printf '\n\n\n'
    printf "%b\n\n\n" "${YELLOW} ufw ${WHITE} (Firewall) is ${RED} inactive"
    sleep 1
    printf '\n\n\n'
    printf "%b\n\n\n" "${LGREEN} Enable it ${WHITE} and ${LGREEN} allow rules ${WHITE}for  Nym-mixnode?\n"
    while true ; do
        read -p  $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;37m] Do you want to continue \e[1;92mYes - (Yy) \e[1;37m or  \e[1;91mNo - (Nn)  ?? :  \e[0m' yn
        printf '\n\n\n'
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
        esac
    done
    ufw allow 1789/tcp > /dev/null 2>&1 && printf "%b\n\n\n" "${YELLOW} port ${LBLUE} 1789 ${WHITE} was ${LGREEN}allowed ${WHITE} in ufw settings"
## Allow ssh just in case
## To avoid locking the user from the server
    ufw allow 22/tcp && ufw limit 22/tcp
    ufw enable
    ufw status
else [ "$is_active" == 1 ]

    printf '\n\n\n'
    printf "%b\n\n\n" "${YELLOW} ufw ${WHITE} (Firewall) is ${LGREEN} active"
    sleep 1
    printf '\n\n\n'
    printf "%b\n\n\n" "${LGREEN} allow rules ${WHITE} for Nym-mixnode?"
    printf "%b\n\n\n"
    while true ; do
        read -p  $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;37m] Do you want to continue \e[1;92mYes - (Yy) \e[1;37m or  \e[1;91mNo - (Nn)  ?? :  \e[0m' yn
        printf '\n\n\n'
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
        esac
    done
    ufw allow 1789/tcp > /dev/null 2>&1 && printf "%b\n\n\n" "${YELLOW} port ${LBLUE} 1789 ${WHITE} was ${LGREEN}allowed ${WHITE} in ufw settings"
    ufw status


fi
}


## This creates systemd.service script
## It looks for multiple files in the /home/nym/.nym/mixnodes directory
## and prompts user for input
## which it then uses to properly print the ExecStart part in the file.
## Useful if you have multiple configs and want to quickly change the node for systemd
function nym_systemd_print() {
  printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
  printf "%b\n\n\n" "${YELLOW} Creating ${WHITE} a systemd service file to run nym-mixnode in the background: "
  printf "%b\n\n\n" "${WHITE} Please select a ${YELLOW} mixnode"
  select d in /home/nym/.nym/mixnodes/* ; do test -n "$d" && break; printf "%b\n\n\n" "${WHITE} >>> Invalid Selection"; done
  directory=$(echo "$d" | rev | cut -d/ -f1 | rev)
  printf "%b\n\n\n"
  printf "%b\n\n\n"
  printf "%b\n\n\n" "${WHITE} You selected ${YELLOW} $directory"
  #echo "You selected $directory"
  printf "%b\n\n\n"
  echo
  printf "%b\n\n\n" "${WHITE} Do you want to create a systemd file for this node?\n\n\n\e[0;31m WARNING: IF YOU ALREADY HAVE ANOTHER NODE CONFIGURED THIS WILL OVERWRITE IT\e[0m\n"
  printf "%b\n\n\n"
    while true ; do
        read -p  $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;37m] Do you want to continue \e[1;92mYes - (Yy) \e[1;37m or  \e[1;91mNo - (Nn)  ?? :  \e[0m' yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
        esac
    done

                #id=$(echo "$i" | rev | cut -d/ -f1 | rev)
                printf '%s\n' "[Unit]" > /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "Description=nym mixnode service" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "After=network.target" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "[Service]" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "Type=simple" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "User=nym" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "LimitNOFILE=65536" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "ExecStart=/home/nym/nym-mixnode_linux_x86_64 run --id $directory" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "KillSignal=SIGINT" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "Restart=on-failure" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "RestartSec=30" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "Restart=on-abort" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "" >> /etc/systemd/system/enym-mixnode.service
                printf '%s\n' "[Install]" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "WantedBy=multi-user.target" >> /etc/systemd/system/nym-mixnode.service
  if [ -e /etc/systemd/system/nym-mixnode.service ]
    then
      printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
      printf "%b\n\n\n" "${WHITE} Your node with id ${YELLOW} $directory ${WHITE} was ${LGREEN} successfully written ${WHITE} to the systemd.service file \n\n\n"
      printf "%b\n\n\n" " ${LGREEN} Enabling ${WHITE} it for you"
      systemctl enable nym-mixnode
      printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
      printf "%b\n\n\n" "${WHITE}   nym-mixnode.service ${LGREEN} enabled!"
    else
      printf "%b\n\n\n" "${WHITE} something went wrong"
      exit 2
  fi
}

## For printing the systemd.service to the current folder
## and not to /etc/systemd/system/ directory
function nym_systemd_print_local() {
  printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
  printf "\e[1;33mPlease select a mixnode:\n"
  select d in /home/nym/.nym/mixnodes/* ; do test -n "$d" && break; printf "%b\n\n\n" "${WHITE} >>> Invalid Selection"; done
  directory=$(echo "$d" | rev | cut -d/ -f1 | rev)
  printf "%b\n\n\n" "${WHITE} You selected ${YELLOW} $directory"
  echo
  printf "%b\n\n\n"
    while true ; do
        read -p  $'\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;37m] Do you want to continue \e[1;92mYes - (Yy) \e[1;37m or  \e[1;91mNo - (Nn)  ?? :  \e[0m' yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
        esac
    done

                #id=$(echo "$i" | rev | cut -d/ -f1 | rev)
                printf '%s\n' "[Unit]" > nym-mixnode.service
                printf '%s\n' "Description=nym mixnode service" >> nym-mixnode.service
                printf '%s\n' "After=network.target" >> nym-mixnode.service
                printf '%s\n' "" >> nym-mixnode.service
                printf '%s\n' "[Service]" >> nym-mixnode.service
                printf '%s\n' "Type=simple" >> nym-mixnode.service
                printf '%s\n' "User=nym" >> nym-mixnode.service
                printf '%s\n' "LimitNOFILE=65536" >> nym-mixnode.service
                printf '%s\n' "ExecStart=/home/nym/nym-mixnode_linux_x86_64 run --id $directory" >> nym-mixnode.service
                printf '%s\n' "KillSignal=SIGINT" >> nym-mixnode.Service
                printf '%s\n' "Restart=on-failure" >> nym-mixnode.service
                printf '%s\n' "RestartSec=30" >> nym-mixnode.service
                printf '%s\n' "" >> nym-mixnode.service
                printf '%s\n' "[Install]" >> nym-mixnode.service
                printf '%s\n' "WantedBy=multi-user.target" >> nym-mixnode.service
    current_path=$(pwd)
    if
      [ -e ${current_path}/nym-mixnode.service ]
    then
      printf "%b\n\n\n" "${WHITE} Your systemd script with id $directory was ${LGREEN} successfully written ${WHITE} to the current directory"
      printf "%b\n" "${YELLOW} $(pwd)"
    else
      printf "%b\n\n\n" "${WHITE} Printing of the systemd script to the current folder ${RED} failed. ${WHITE} Do you have ${YELLOW} permissions ${WHITE} to ${YELLOW} write ${WHITE} in ${pwd} ${YELLOW}  directory ??? "
    fi
}

## Checks if the path is correct and then prompts user for input to get $id and optional $location.
## Then runs the binary with the given input from user and builds config.
function nym_init() {
 #get server's ipv4 address
 ip_addr=`curl -sS ipinfo.io/ip`
 printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
 printf "%b\n\n\n" "${YELLOW} Configuration ${WHITE} file and keys: "
 if
   pwd | grep /home/nym > /dev/null 2>&1
 then
   printf "%b\n\n\n" "${WHITE} What name do you want for your node ${YELLOW} id? "
   printf "%b\n\n\n" "${WHITE} This is only for your own purposes and creates a directory with that name in ${YELLOW}/home/nym/.nym/mixnodes/<YOURID>. ${YELLOW} Config ${WHITE} and ${YELLOW} keys ${WHITE}are stored there "
   printf "%b\n\n\n"
   read id
   printf "%b\n\n\n"
   printf "%b\n\n\n" "${WHITE} Your node name will be ${YELLOW} $id. ${WHITE} Use it nextime if you restart your server or the node is not running"
   printf "%b\n\n\n"
   printf "%b\n\n\n" "${WHITE} Where is your server located? Leave blank if you would rather not tell ...${LBLUE}"
   printf "%b\n\n\n"
   read location
   if [[ -z "${location// }" ]] ; then location="unknown" ; fi
   printf "%b\n\n\n"
   printf "%b\n\n\n" "${WHITE} Enter the Liquid-BTC address for the incentives rewards"
   printf "%b\n\n\n"
   read wallet
   printf "%b\n\n\n" "${WHITE} Address for the incentives rewards will be ${YELLOW} ${wallet} "
   read
   printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
   # borrows a shell for nym user to initialize the node config.
   sudo -u nym -H ./nym-mixnode_linux_x86_64 init --id $id --location $location --host $ip_addr --incentives-address $wallet
   printf "%b\n\n\n"
   printf "%b\n\n\n" "${WHITE}  Your node has id ${YELLOW} $id ${WHITE} located in ${LBLUE} $location ${WHITE} with ip ${YELLOW} $ip_addr ${WHITE}... "
   printf "%b\n\n\n" "${WHITE} Config was ${LGREEN} built successfully ${WHITE}!"
 else
   printf "%b\n\n\n" "${WHITE} Something went ${RED} wrong {WHITE}..."
   exit 2
 #set +x
 fi
}
function nym_systemd_run() {
    printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
    printf "%b\n\n\n" "${YELLOW} Launching ${WHITE} the node: "
    printf "%b\n\n\n"
    printf "%b\n\n\n" "${WHITE} Please select a ${YELLOW} mixnode"
    printf "%b\n\n\n"
    select d in /home/nym/.nym/mixnodes/* ; do test -n "$d" && break; printf "%b\n\n\n" "${WHITE} >>> Invalid Selection"; done
    directory=$(printf "%b\n\n\n" "${WHITE}$d" | rev | cut -d/ -f1 | rev)
    printf "\e[1;82mYou selected\e[0m\e[3;11m ${WHITE} $directory\e[0m\n"
    printf "%b\n\n\n"

    service_id=$(cat /etc/systemd/system/nym-mixnode.service | grep id | cut -c 55-)


   ## Check if user chose a valid node written in the systemd.service file
    if [ "$service_id" == "$directory" ]
    then
      printf "%b\n\n\n"
      printf "%b\n\n\n" "${YELLOW} Launching ${service_id} ..."
      systemctl start nym-mixnode.service
    else
      printf "%b\n\n\n" "${WHITE} The node you selected is ${RED} not ${WHITE} in the  ${YELLOW} nym-mixnode.service ${WHITE} file. Create a new systemd.service file with ${LBLUE} sudo ./nym-install.sh -p"
      exit 1
    fi

   ## Check if the node is running successfully
    if
      systemctl status nym-mixnode | grep -e "active (running)" > /dev/null 2>&1
    then
      printf "%b\n\n\n"
      printf "%b\n\n\n" "${WHITE} Your node ${YELLOW} ${service_id} ${WHITE} is ${LGREEN} up ${WHITE} and ${LGREEN} running!!!!"
    else
      printf "%b\n\n\n" "${WHITE} Node is ${RED} not running ${WHITE} for some reason ...check it ${LBLUE} ./nym-install.sh -s [--status]"
    fi
  }



## Print the status nym-mixnode.service
function nym_status() {
  systemctl status nym-mixnode | more
  if
      systemctl status nym-mixnode | grep -e "active (running)" > /dev/null 2>&1
    then
      printf "%b\n\n\n"
      printf "%b\n\n\n" "${WHITE} Your ${YELLOW} node ${WHITE} is ${LGREEN} up ${WHITE} and ${LGREEN} running ${WHITE}!"
      printf "%b\n\n\n"
  elif
      systemctl status nym-mixnode | more | grep -i inactive  > /dev/null 2>&1
    then
      printf "%b\n\n\n"
      printf "%b\n\n\n" "${WHITE} Your ${YELLOW} node ${RED}is not running ${WHITE}. Run the script with -r option"
      printf "%b\n\n\n"
  fi
}

## Download the latest version of the binaries
function downloader () {
#set -x
if [ ! -d /home/nym/.nym/mixnodes ]
then
	# todo: add option to set the user and PATH for the mixnode but eventually decided not to this at the moment...seems unneccessary
	echo "Looking for nym config in /home/nym but could not find any! Enter the path of the nym-mixnode executable"
	exit 1
else
	cd /home/nym
fi

# set vars for version checking and url to download the latest release of nym-mixnode
current_version=$(./nym-mixnode_linux_x86_64 --version | grep Nym | cut -c 13- )
VERSION=$(curl https://github.com/nymtech/nym/releases/latest --cacert /etc/ssl/certs/ca-certificates.crt 2>/dev/null | egrep -o "[0-9|\.]{5}(-\w+)?")
URL="https://github.com/nymtech/nym/releases/download/v$VERSION/nym-mixnode_linux_x86_64"

# Check if the version is up to date. If not, fetch the latest release.
if [ ! -f nym-mixnode_linux_x86_64 ] || [ "$(./nym-mixnode_linux_x86_64 --version | grep Nym | cut -c 13- )" != "$VERSION" ]
   then
       if systemctl list-units --state=running | grep nym-mixnode
          then echo "stopping nym-mixnode.service to update the node ..." && systemctl kill --signal=SIGINT nym-mixnode
                curl -L -s "$URL" -o "nym-mixnode_linux_x86_64" --cacert /etc/ssl/certs/ca-certificates.crt && echo "Fetching the latest version" && pwd
          else echo " nym-mixnode.service is inactive or not existing. Downloading new binaries ..." && pwd
    		curl -L -s "$URL" -o "nym-mixnode_linux_x86_64" --cacert /etc/ssl/certs/ca-certificates.crt && echo "Fetching the latest version" && pwd
	   # Make it executable
   chmod +x ./nym-mixnode_linux_x86_64 && chown nym:nym ./nym-mixnode_linux_x86_64
   fi
else
   echo "You have the latest version of Nym-mixnode $VERSION"
   exit 1

fi
}
function upgrade_nym () {
#set -x
cd /home/nym
select d in /home/nym/.nym/mixnodes/* ; do test -n "$d" && break; printf "%b\n\n\n" "${WHITE} >>> Invalid Selection"; done
directory=$(echo "$d" | rev | cut -d/ -f1 | rev)
printf "%b\n\n\n"
printf "%b\n\n\n" "${WHITE} You selected ${YELLOW} $directory"
sleep 2
printf "%b\n\n\n" "${WHITE} Enter the Liquid-BTC address for the incentives rewards"
read wallet
printf "%b\n\n\n"
printf "%b\n\n\n" "${WHITE} Address for the incentives rewards will be ${YELLOW} ${wallet} "
printf "%b\n\n\n" "${WHITE} You may later change it in config.toml if needed, but you need to stop the node first and then edit it with an editor such as nano"

sudo -u nym -H ./nym-mixnode_linux_x86_64 upgrade --id $directory --incentives-address $wallet --current-version $current_version
}
#set -x

function mixnode_update () {
downloader && echo "ok" && sleep 2 || exit 1
upgrade_nym && sleep 5 && systemctl start nym-mixnode.service && printf "%b\n\n\n" "${WHITE} Check if the update was successful - ./nym_install.sh -s ${NOCOLOR}"
}




## display usage if the script is not run as root user
	if [[ $USER != "root" ]]
	then
    printf "%b\n\n\n" "${WHITE} This script must be run as ${YELLOW} root ${WHITE} or with ${YELLOW} sudo!"
		exit 1
	fi
## Full install, config and launch of the nym-mixnode
  if [ "$1" = "-i" ]; then
    while [ ! -d /home/nym ] ; do nym_usercreation ; done
    cd /home/nym/ || printf "%b\n\n\n" "${WHITE}failed sorry"
    if [ ! -e /home/nym/nym-mixnode_linux_x86_64 ] ; then nym_download ; fi
    nym_chmod
    nym_chown
    nym_init
    nym_systemd_print
    nym_ufw
    nym_systemd_run
    printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
    printf "%b\n" "${WHITE}                     Make sure to also check the official docs ! "
    printf "%b\n\n\n"
    printf "%b\n" "${LGREEN}                            https://nymtech.net/docs/"
    printf "%b\n\n\n"
    printf "%b\n" "${WHITE}                              Check the dashboard"
    printf "%b\n\n\n"
    printf "%b\n" "${LBLUE}                          https://dashboard.nymtech.net/"
    printf "%b\n\n\n"
    printf "%b\n" "${WHITE}                                       or"
    printf "%b\n\n\n"
    printf "%b\n" "${YELLOW}                           ./nym_install.sh --status"
    printf "%b\n\n\n"
    printf "%b\n" "${WHITE}                              to see how many packets"
    printf "%b\n\n\n"
    printf "%b\n" "${WHITE}                            You have ${YELLOW} mixed ${WHITE} so far ! "
    printf "%b\n\n\n"
    printf "%b\n\n\n" "${WHITE} --------------------------------------------------------------------------------"
  fi
## Configure the node
  if [[ ("$1" = "--init") ||  "$1" = "-c" ]]
  then
    cd /home/nym/ > /dev/null 2>&1 && nym_init || printf "%b\n" "\n\n\n${YELLOW} /home/nym/ ${RED} does not exist. ${WHITE} Create it with the ${YELLOW} -i ${WHITE} or ${YELLOW} --install ${WHITE} flag first.\n\n\n"
  fi
## Create the systemd.service file
  if [[ ("$1" = "--print") ||  "$1" = "-p" ]]
  then
    cd /home/nym/  > /dev/null 2>&1 && nym_systemd_print || printf "%b\n" "\n\n\n${YELLOW} /home/nym/ ${RED} does not exist. ${WHITE} Create it with the ${YELLOW} -i ${WHITE} or ${YELLOW} --install ${WHITE} flag first.\n\n\n"

  fi
##  Create the systemd.service file locally
  if [[ ("$1" = "--print-local") ||  "$1" = "-l" ]]
  then
  cd /home/nym/  > /dev/null 2>&1 && nym_systemd_print_local || printf "%b\n" "\n\n\n${YELLOW} /home/nym/ ${RED} does not exist. ${WHITE} Create it with the ${YELLOW} -i ${WHITE} or ${YELLOW} --install ${WHITE} flag first.\n\n\n"
    nym_systemd_print_local
  fi
## Run the node
  if [[ ("$1" = "--run") ||  "$1" = "-r" ]]
  then
    cd /home/nym/.nym/mixnodes/ > /dev/null 2>&1  && nym_systemd_run || printf "%b\n" "\n\n\n${RED}no${YELLOW} config ${RED} found ${WHITE} Create it with the ${YELLOW} -c ${WHITE} or ${YELLOW} --init ${WHITE} flag first.\n\n\n"
  fi
## Get status from the systemdaemon file
  if [[ ("$1" = "--status") ||  "$1" = "-s" ]]
  then
    nym_status
  fi

## Setup the firewall
  if [[ ("$1" = "--firewall") ||  "$1" = "-f" ]]
  then
    nym_ufw
  fi
## If no arguments supplied, display usage
  if [ -z "$1" ]
  then
    display_usage
  fi

## Check whether user had supplied -h or --help . If yes display usage
  if [[ ("$1" = "--help") ||  "$1" = "-h" ]]
  then
    display_usage
	exit 0
  fi
## Prints the version of Nym used
  if [[ ("$1" = "--version") ||  "$1" = "-V" ]]
  then
     display_usage
	exit 0
  fi
## Update the node -
## 1. See if nym-mixnode.service is running - if yes stop it
## 2. fetch the latest binaries
## 3. ./nym-mixnode upgrade and let user choose id and incentives Address
## 4. run the nym-mixnode.service again
  if [[ ("$1" = "--update") ||  "$1" = "-u" ]]
  then
    mixnode_update || printf "%b\n" "\n\n\n${WHITE} Something went ${RED} wrong. ${NOCOLOR}"
  fi

#nym_usercreation
#nym_download
#nym_chmod
#nym_chown
#nym_init
#nym_run
