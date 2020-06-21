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

OPTIONS:

        --id                node id name
EOF
} 

#if [ -z "$1" ]; then
#usage 
#fi

usage() {
    cat 1>&2 <<EOF
nym_autoinstall 1.0 (2019-21-06)
The installer and launcher for Nym mixnode

USAGE:
    ./nym_autoinstall.sh [FLAGS] 

FLAGS:
    -i --install            Full installation and setup
    -c --config             Run only the init command without installation                    
    -r, --run               Start the node without installation
    -h, --help              Prints help information
    -V, --version           Prints version information
EOF
}

nym_usercreation() {
  
  echo "Creating nym user"
  useradd -U -m -s /sbin/nologin nym
  echo
 if ls -a /home/ | grep nym > /dev/null
 then
 echo "user nym created with a home directory at /home/nym/"
 else
  echo "something went wrong and the user nym was not created. Are you running this as root?"
 fi
}


nym_download() {
 if
   cat /etc/passwd | grep nym > /dev/null
 then
   echo "Downloading nym-mixnode binaries for the nym user ..."
   cd /home/nym && curl -LO https://github.com/nymtech/nym/releases/download/v0.7.0/nym-mixnode_linux_x86_64
 else
   echo "Download failed..."
#echo "Could not get into nym user shell ...exiting"
 fi
}



nym_chmod() {
 if ls -la /home/nym/ | grep nym-mixnode_linux_x86_64 >/dev/null
 then
   echo "Making the nym binary executable ..."
   chmod 755 /home/nym/nym-mixnode_linux_x86_64
 else
   echo "Something went wrong, wrong path..?"
 fi
}

nym_chown() {
 chown -R nym:nym /home/nym/
 echo "Changed ownership to nym:nym"
}
ip_addr=`curl -sS v4.icanhazip.com`
nym_init() {
 #set -x
 ip_addr=`curl -sS v4.icanhazip.com`
 if
   pwd | grep /home/nym > /dev/null
 then
   echo "What name do you want for your node id?"
   read id
   echo
   echo "Your node name will be $id. Use it nextime if you restart your server or the node is not running"
   echo
   echo "Where is your server located? Leave blank if you would rather not tell ..."
   read location
   sudo -u nym ./nym-mixnode_linux_x86_64 init --id $id --layer 2 --location $location --host $ip_addr
   printf "Your node has id $id located in $location with ip $ip_addr \n ...\n Config built!\n"
 else
   echo "WTF"
 #set +x
 fi
}

nym_run() {
 if
   ls -la /home/nym/.nym/mixnodes/ | grep $id > /dev/null
 then
   printf "Trying to run the node with nohup to make it persistent ...\n"
   sudo -u nym nohup ./nym-mixnode_linux_x86_64 run --id $id &
 else
   "Something went wrong ..."
 fi
}

# full install and setup  
  if [ "$1" = "-i" ]; then
    nym_usercreation
    nym_download
    nym_chmod
    nym_chown
    nym_init
    nym_run

  fi
# run the node 
  if [ "$1" = "-c" ]; then
    cd /home/nym/
    nym_init
  fi
# run the node 
  if [ "$1" = "-r" ]; then
    cd /home/nym/
    nym_run
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
