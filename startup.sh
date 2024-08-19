#!/bin/bash

#start up main container to make it quicker to enter in future
_hostname=$(hostnamectl hostname)
_cont_suffix="-c"
if [ -z _hostname ]; then
  echo could not get host name!
else
  container_host="${_hostname}${_cont_suffix}"
  exec distrobox-enter $container_host
fi



