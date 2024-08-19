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
_cont_suffix="-c"
echo Setting hostname for container based on $_hostname
if [ _hostname >&2 ]; then
  container_host="${_hostname}${_cont_suffix}"
  echo Creating distrobox container for $container_host ...
  distrobox-create -n $container_host
else
  echo could not get host name!
fi
	

echo Setup is complete.
	
