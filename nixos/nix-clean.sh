#!/usr/bin/env bash

sudo nix-env --delete-generations +5 --profile /nix/var/nix/profiles/system
sudo nix-collect-garbage
sudo nixos-rebuild boot --flake ~/nix
