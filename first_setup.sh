#!/bin/bash

#check distrobox is installed
pre_req_met=1
echo checking to see if distrobox is installed...
if command -v distrobox >&2; then
  echo     distrobox is installed
else
  echo Please install distrobox and rerun this script!
  pre_req_met=0
fi

#Packages names are distro dependent. In future we will use the .yaml stack files from Vanialla OS.
#We will need to autodetct the distro and select the stack file acccordingly.
#note: to detect OS name use /etc/os-release
additional_pkgs="git vim"

#echo Checking to see if git is installed...
#if command -v git >&2; then
#  echo     git is installed
#else
#  echo Please install git and rerun this script!
#  pre_req_met=0
#fi


if [ $pre_req_met -eq 1 ]; then
	echo "Prerequisites have been met!"
else
	echo "Prerequisites have not been met, cannot continue"
	exit
fi

_hostname=$(hostnamectl hostname)
_cont_suffix="-cc"
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
	
