#!/bin/bash

#script to run scribe in a virtual environment (venv)

_hostname=$(hostnamectl hostname)
_cont_suffix="-c"
if [ -z _hostname ]; then
  echo could not get host name!
else
  container_host="${_hostname}${_cont_suffix}"
  distrobox-enter $container_host -e python3 ~/.local/bin/scribe/scribe.py
fi
