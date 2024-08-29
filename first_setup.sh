#!/bin/bash
has_git=false
has_distrobox=false

echo Checking to see if git is installed...
if command -v git >&2; then
    echo git is installed
    has_git=true
    git config --global user.name marcs100
    git config --global user.email marcs100@gmail.com
    mkdir ~/source
    git clone https://github.com/marcs100/scripts.git ~/source/scripts
    git clone https://github.com/marcs100/stacks.git ~/source/stacks
    git clone https://github.com/marcs100/autostart.git ~/source/autostart  
else
    echo Warning: Git is not installed will not clone repos.
fi

#check distrobox is installed
echo checking to see if distrobox is installed...
if command -v distrobox >&2; then
  has_distrobox=true
  echo distrobox is installed
fi

if [ "$has_git" =  true ]; then
    #install scribe
    ~/source/scribe/install.sh
    cp ~/source/srcibe/scribe.desktop ~/.local/share/applications
    
    #copy script to aouto start main distrobox container
    if [ "$has_distrobox" = true ]; then
	mkdir ~/.config/autostart
        cp ~source/scripts/startup.sh ~/.config/autostart
    fi
fi    

if [ "$has_distrobox" = false]; then
    echo please install distobox and rerun this script to continue
    exit
fi


#Packages names are distro dependent. In future we will use the .yaml stack files from Vanialla OS.
#We will need to autodetct the distro and select the stack file acccordingly.
#note: to detect OS name use /etc/os-release
if [ -f /etc/os-release ]; then
    # freedesktop.org and systemd
    . /etc/os-release
    OS=$NAME
fi

case $OS in
  "Aeon" | "openSUSE Tumbleweed" | "Kalpa")
    additional_pkgs="neovim git  python311-tk"
    ;;
  "Arch Linux")
    additional_pkgs="neovim git micro tk"
    ;;
  "Fedora Linux") #to do add silverblue and kinote once I verify the names
    additional_pkgs="vim git micro python-tkinter"
    ;;
  "Ubuntu")
    additional_pkgs="neovim git micro python3-tk"
    ;;
  "Debian GNU/Linux")
    additional_pkgs="neovim git micro python3-tk"
    ;;
  *)
    echo Warning: Could not determine distro, will not add any additioanl packages!
    additional_pkgs=""
    ;;
esac

echo Distro: $OS

_hostname=$(hostnamectl hostname)
_cont_suffix="-c"
echo Setting hostname for container based on $_hostname
if [ _hostname >&2 ]; then
  container_host="${_hostname}${_cont_suffix}"
  echo Creating distrobox container for $container_host ...
  if [ -z $additional_pkgs ]; then
    distrobox-create -n $container_host
  else
    #echo distrobox-create -n $container_host --additional-packages $additional_pkgs
    distrobox-create -n $container_host --additional-packages "$additional_pkgs"
  fi
else
  echo could not get host name!
  exit
fi
	

echo Setup is complete.
	
