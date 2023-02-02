#!/bin/bash

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

# Define the list of packages to install
packages=(btop git lolcat figlet cowsay fish conky inxi timeshift alacritty cpu-x digikam exa ripgrep kalendar kdenlive kmail krita mc neofetch rawtherapee)

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
