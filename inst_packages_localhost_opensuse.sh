#!/bin/bash

# User to setup profile and other files for
SETUP_USER=throttlemeister

# Check if Ansible is installed
if ! command -v ansible-playbook >/dev/null; then
  echo "Ansible is not installed. Installing Ansible now..."
  # Install Ansible
  sudo zypper in -y ansible
fi

# Define the list of packages to install
packages=(opi stow neovim btop git lolcat figlet cowsay fish conky inxi alacritty cpu-x digikam eza ripgrep kalendar kdenlive kmail krita mc fastfetch rawtherapee ktorrent)

# Create an Ansible playbook
cat >install-packages.yml <<EOL
- name: Install Packages
  hosts: localhost
  become: yes
  tasks:
EOL

# Add tasks for each package
for package in "${packages[@]}"; do
  cat >>install-packages.yml <<EOL
    - name: Install $package
      package:
        name: $package
        state: present
EOL
done

# Run the Playbook
ansible-playbook install-packages.yml

# Clean up the playbook file when we are done
rm install-packages.yml

# Install MS Edge and VS Code from OPI
opi -n msedge
opi -n vscode

# Clone ansible and setup profile
cd /home/$SETUP_USER/
git clone git@github.com:throttlemeister/ansible.git
cd /home/$SETUP_USER
tar xvfz ansible/files/profile_local.tar.gz

# Clone dotfiles and use stow to setup the rest of the stuff
cd /home/$SETUP_USER/
mkdir .dotfiles
cd .dotfiles
git clone git@github.com:throttlemeister/dotfiles.github .
stow *

# Finally setup LazyVIM
git clone https://github.com/LazyVim/starter /home/$SETUP_USER/.config/nvim
