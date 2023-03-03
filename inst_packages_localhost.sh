#!/bin/bash

# User to setup profile and other files for
SETUP_USER=throttlemeister

# Check if Ansible is installed
if ! command -v ansible-playbook > /dev/null; then
  echo "Ansible is not installed. Installing Ansible now..."

  # Determine the package manager to use for installing Ansible
  if command -v dnf > /dev/null; then
    package_manager="dnf install -y"
  elif command -v apt-get > /dev/null; then
    package_manager="apt-get install -y"
  else
    echo "Neither dnf nor apt-get was found. Please install one of them."
    exit 1
  fi

  # Install Ansible
  $package_manager ansible
fi

# If we are running dnf we check for MS reposiroties and install if needed
if command -v dnf > /dev/null; then
  dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
  if [ -d /etc/yum.repos.d/microsoft-edge.repo ]; then
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo cp /home/backup/etc/microsoft-edge.repo /etc/yum.repos.d
  fi
  if [ -d /etc/yum.repos.d/vscode.repo ]; then
    rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo cp /home/backup/etc/microsoft-vscode.repo /etc/yum.repos.d
  fi
fi

# Do the same as previous, but on a apt based system like Debian or Ubuntu
#if command -v apt-get > /dev/null; then
#  apt-get install wget gpg
#  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
#  install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
#  if [ -d /usr/bin/code ]; then
#    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/code stable main"
#    apt install apt-transport-https
#    apt update
#    apt install code
#  fi
#  if [ -d /usr/bin/microsoft-edge-stable ]; then
#    add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
#    apt install microsoft-edge-stable
#fi

# Define the list of packages to install
packages=(btop git lolcat figlet cowsay fish conky inxi alacritty cpu-x digikam exa ripgrep kalendar kdenlive kmail krita mc neofetch rawtherapee code microsoft-edge-stable)

# Create an Ansible playbook
cat > install-packages.yml << EOL
- name: Install Packages
  hosts: localhost
  become: yes
  tasks:
EOL

# Determine the package manager to use
if command -v dnf > /dev/null; then
  package_manager="dnf"
elif command -v apt-get > /dev/null; then
  package_manager="apt"
else
  echo "Neither dnf nor apt-get was found. Please install one of them."
  exit 1
fi

# Add tasks for each package
for package in "${packages[@]}"; do
  cat >> install-packages.yml << EOL
    - name: Install $package
      $package_manager:
        name: $package
        state: present
EOL
done

# Run the Ansible playbook
ansible-playbook install-packages.yml

# Clean up the playbook file
rm install-packages.yml

# Setup profile
cd /home/$SETUP_USER
tar xvfz /home/backup/profile_proper.tar.gz

# Clone fish configuration and ansible
cd /home/$SETUP_USER/.config
git clone git@github.com:throttlemeister/fish.git
cd /home/$SETUP_USER/
git clone git@github.com:throttlemeister/ansible.git

