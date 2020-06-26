#!/bin/bash
#   
# 
#
#
#
#
#
#
#
#
#
#
display_usage() { 
	#echo "This script must be run with super-user privileges." 
	#echo -e "\nUsage:\n__g5_token5eefd24a11c4a [arguments] \n" 


      cat 1>&2 <<EOF
nym_autoinstall 1.0 (2019-21-06)
The installer and launcher for Nym mixnode

USAGE:
    ./nym_autoinstall.sh [FLAGS] [OPTIONS]

FLAGS:
    -i --install            Full installation and setup
    -c --config             Run only the init command without installation                    
    -r, --run               Start the node without installation
    -h, --help              Prints help information
    -V, --version           Prints version information
    -s  --status            Prints status of the running node

OPTIONS:

        --id                node id name
EOF
} 

# Colours variables for the installation script
#
# credits to some dude on stackoverflow , he might be colourblind tho
#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

RED='\033[1;31m'
WHITE='\033[1;37m'
DBLUE='\033[0;34m'
LBLUE='\033[1;34m'
YELLOW='\033[1;33m'
LGREEN='\033[1;32m'
#GOLDEN='\033[0;33m'
NOCOLOR='\033[0m' # No Color
#printf "I ${RED}love${NC} Stack Overflow\n"
#while true; do
#printf "${RED}LOVE\n\n${YELLOW}IS\n\n${LBLUE}ALL\n\n${WHITE}YOU\n\n${LGREEN}\nNEED\n\n ${RED}========${YELLOW}========${LBLUE}========${WHITE}========${LGREEN}========\n\n"
#sleep 1
#done

# creates a user nym with home directory
function nym_usercreation() {
  
  echo "Creating nym user"
  echo
 if ls -a /home/ | grep nym > /dev/null 2>&1
 then
 echo "user nym created with a home directory at /home/nym/"
 else
  echo "something went wrong and the user nym was not created. Are you running this as root?"
 fi
}

# Check if nym user exists and then download the latest nym-mixnode binaries to nym home directory
function nym_download() {
 if
   cat /etc/passwd | grep nym > /dev/null 2>&1
 then
   echo "Downloading nym-mixnode binaries for the nym user ..."
   cd /home/nym && curl -LO https://github.com/nymtech/nym/releases/download/v0.7.0/nym-mixnode_linux_x86_64
 else
   echo "Download failed..."
 fi
}


# checks for the binaries and then makes them executable 
function nym_chmod() {
  test -x nym-mixnode_autoinstall.sh ; echo $?
 if ls -la /home/nym/ | grep nym-mixnode_linux_x86_64 > /dev/null 2>&1
 then
   echo "Making the nym binary executable ..."
   chmod 755 /home/nym/nym-mixnode_linux_x86_64
 else
   echo "Something went wrong, wrong path..?"
 fi
}

# change ownerships of all files within nym home directory / they were downloaded as root so now we return them back to nym
function nym_chown() {
 chown -R nym:nym /home/nym/
 echo "Changed ownership to nym:nym"
}

# Get server ipv4 
ip_addr=`curl -sS v4.icanhazip.com`

# This creates systemd.service script 
# It looks for multiple files in the /home/nym/.nym/mixnodes directory
# and prompts user for input 
# which it then uses to properly print the ExecStart part in the file.
# Useful if you have multiple configs and want to quickly change the node from systemd
function nym_systemd_print() {
  printf "\e[1;33mPlease select a mixnode:\n"
  select d in /home/nym/.nym/mixnodes/* ; do test -n "$d" && break; echo ">>> Invalid Selection"; done
  directory=$(echo "$d" | rev | cut -d/ -f1 | rev)
  printf "\e[1;82mYou selected\e[0m\e[3;11m $directory\e[0m\n"
  #echo "You selected $directory"
  echo
  printf "\e[1;82mDo you want to create a systemd file for this node?\n\e[0;31mWARNING: IF YOU ALREADY HAVE ANOTHER NODE CONFIGURED THIS WILL OVERWRITE IT\e[0m\n"
    
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
                printf '%s\n' "ExecStart=/home/nym/nym-mixnode_linux_x86_64 run --id $directory" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "Restart=on-abort" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "" >> /etc/systemd/system/enym-mixnode.service
                printf '%s\n' "[Install]" >> /etc/systemd/system/nym-mixnode.service
                printf '%s\n' "WantedBy=multi-user.target" >> /etc/systemd/system/nym-mixnode.service    
  if [ -e /etc/systemd/system/nym-mixnode.service ]
    then
      printf "${WHITE}Your node with id ${YELLOW} $directory ${WHITE} was ${LGREEN} successfully written${WHITE} to the systemd.service file \n\n\n"
      printf "You may now enable it with ${LBLUE}sudo systemctl enable nym-mixnode\n\n\n" 
      printf "Doing it for you ..."
      systemctl enable nym-mixnode
    else 
      printf "something went wrong"
      exit 2
  fi
}

# For printing the systemd.service to the current folder 
# and not to /etc/systemd/system/ directory

function nym_systemd_print_local() {
  printf "\e[1;33mPlease select a mixnode:\n"
  select d in /home/nym/.nym/mixnodes/* ; do test -n "$d" && break; echo ">>> Invalid Selection"; done
  directory=$(echo "$d" | rev | cut -d/ -f1 | rev)
  printf "\e[1;82mYou selected\e[0m\e[3;11m $directory\e[0m\n"
  #echo "You selected $directory"
  echo
  printf "\e[1;82mDo you want to create a systemd file for this node?\n\e[0;31mWARNING: IF YOU ALREADY HAVE ANOTHER NODE CONFIGURED THIS WILL OVERWRITE IT\e[0m\n"
    
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
                printf '%s\n' "ExecStart=/home/nym/nym-mixnode_linux_x86_64 run --id $directory" >> nym-mixnode.service
                printf '%s\n' "Restart=on-abort" >> nym-mixnode.service
                printf '%s\n' "" >> nym-mixnode.service
                printf '%s\n' "[Install]" >> nym-mixnode.service
                printf '%s\n' "WantedBy=multi-user.target" >> nym-mixnode.service    
        
}
# checks if the path is correct and then prompts user for input to get $id and optional $location. 
# Then runs the binary with the given input from user and builds config.
function nym_init() {
 #get server's ipv4 address 
 ip_addr=`curl -sS v4.icanhazip.com`
 if
   pwd | grep /home/nym > /dev/null 2>&1
 then
   echo "What name do you want for your node id?"
   read id
   echo
   echo "Your node name will be $id. Use it nextime if you restart your server or the node is not running"
   echo
   echo "Where is your server located? Leave blank if you would rather not tell ..."
   read location
   # borrows a shell for nym user to initialize the node config. 
   sudo -u nym ./nym-mixnode_linux_x86_64 init --id $id --layer 2 --location $location --host $ip_addr
   printf "Your node has id $id located in $location with ip $ip_addr \n ...\n Config built!\n"
 else
   echo "Something went wrong ..."
 #set +x
 fi
}
function nym_systemd_run() { 
    printf "\e[1;33mPlease select a mixnode:\n"
    select d in /home/nym/.nym/mixnodes/* ; do test -n "$d" && break; echo ">>> Invalid Selection"; done
    directory=$(echo "$d" | rev | cut -d/ -f1 | rev)
    printf "\e[1;82mYou selected\e[0m\e[3;11m $directory\e[0m\n"

    service_id=$(cat /etc/systemd/system/nym-mixnode.service | grep id | cut -c 55-
)

   
   # Check if user chose a valid node written in the systemd.service file
    if [ "$service_id" == "$directory" ]
    then
      echo "Launching ${service_id} ..."
      systemctl start nym-mixnode.service
    else 
      echo "The node you selected is not in the nym-mixnode.service file. Create a new systemd.service file with sudo ./nym-install.sh -p"
      exit 1
    fi

   # Check if the node is running successfully
    if 
      systemctl status nym-mixnode | grep -e "active (running)" > /dev/null 2>&1
    then  
      echo "Your node ${service_id} is up and running !!!"
    else 
      echo "Node is not running for some reason ...check it ./nym-install.sh -s [--status]"
    fi  
  }



# Print the status of the nohup.out file
function nym_status() {
  systemctl status nym-mixnode | more
  if 
      systemctl status nym-mixnode | grep -e "active (running)" > /dev/null 2>&1
    then 
      echo "Your node is up and running!"
  elif
      systemctl status nym-mixnode | more | grep -i inactive  > /dev/null 2>&1 
    then
      echo "Your node is not running. Run the script with -r option"
  fi
}

# full install and setup  
  if [ "$1" = "-i" ]; then
    nym_usercreation
    nym_download
    nym_chmod
    nym_chown
    nym_init
    nym_systemd_print
    nym_systemd_run

  fi
# configure the node 
  if [ "$1" = "-c" ]; then
    cd /home/nym/
    nym_init
  fi
# Create the systemd.service file
 if [ "$1" = "-p" ]; then
    cd /home/nym/
    nym_systemd_print
  fi
#  Create the systemd.service file locally
 if [ "$1" = "-l" ]; then
    cd /home/nym/
    nym_systemd_print_local
  fi
# run the node 
  if [ "$1" = "-r" ]; then
    cd /home/nym/
    nym_systemd_run
  fi
# get status from the nohup.out file 
  if [ "$1" = "-s" ]; then
    cd /home/nym/
    nym_status
  fi
# if no arguments supplied, display usage 
  if [ -z "$1" ]
  then
    display_usage 
  fi
 
# check whether user had supplied -h or --help . If yes display usage 
	if [[ ("$1" = "--help") ||  "$1" = "-h" ]] 
  #if [[ ( $# == "--help") ||  $# == "-h" ]]
	then 
		display_usage
		exit 0
	fi 
 
# display usage if the script is not run as root user 
	if [[ $USER != "root" ]]; then 
		echo "This script must be run as root!" 
		exit 1
	fi 
#nym_usercreation
#nym_download
#nym_chmod
#nym_chown
#nym_init
#nym_run
