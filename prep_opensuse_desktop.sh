#!/bin/bash

# User to setup profile and other files for
SETUP_USER=throttlemeister

# Clone ansible repo and setup profile
cd /home/$SETUP_USER/
git clone git@github.com:throttlemeister/ansible.git
cd /home/$SETUP_USER
tar xvfz ansible/files/profile_local.tar.gz

# Check if Ansible is installed
if ! command -v ansible-playbook >/dev/null; then
  echo "Ansible is not installed. Installing Ansible now..."
  # Install Ansible
  sudo zypper in -y ansible
fi

# Run the Ansible playbook to install standard packages
ansible-playbook files/install_local_packages.yml

### START OF OLD STUFF - TO BE REMOVED

## Define the list of packages to install
#packages=(opi stow neovim btop git lolcat figlet cowsay fish conky inxi alacritty cpu-x digikam eza ripgrep kalendar kdenlive kmail krita mc fastfetch rawtherapee ktorrent)

## Create an Ansible playbook
#cat >install-packages.yml <<EOL
#- name: Install Packages
#  hosts: localhost
#  become: yes
#  tasks:
#EOL

## Add tasks for each package
#for package in "${packages[@]}"; do
#  cat >>install-packages.yml <<EOL
#    - name: Install $package
#      package:
#        name: $package
#        state: present
#EOL
#done

## Run the Playbook
#ansible-playbook install-packages.yml

## Clean up the playbook file when we are done
#rm install-packages.yml

## Install MS Edge and VS Code from OPI
#opi -n msedge
#opi -n vscode

### END OF OLD stuff

# Clone dotfiles repo and use stow to setup the rest of the stuff
cd /home/$SETUP_USER/
mkdir .dotfiles
cd .dotfiles
git clone git@github.com:throttlemeister/dotfiles.github .
stow *

# Finally setup LazyVIM so we can have a nice VI experience.
git clone https://github.com/LazyVim/starter /home/$SETUP_USER/.config/nvim
