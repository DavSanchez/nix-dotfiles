#! /bin/bash

sudo mv /etc/bashrc /etc/bashrc.orig
sudo mv /etc/zshrc /etc/zshrc.orig
sudo mv /etc/zprofile /etc/zprofile.orig
sudo /nix/var/nix/profiles/system/activate
exit  # Start a new shell to reload the environment.