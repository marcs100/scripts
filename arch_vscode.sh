#!/bin/bash

cd ~
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
yay -Sy --noconfirm visual-studio-code-bin
