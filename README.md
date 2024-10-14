**Ansible**

A small collection of ansible scripts for me to set up new machines.
- ansible.cfg: basic ansible configuration
- bootstrap.yml: bootstrap a fresh server/VM install
- inventory.yml: where all the servers live for ansible
- profile.yml: to set up a basic user profile for a specified user
- site.yml: after bootsrapping the server, install a basic set of software, independent of distribution
- user.yml: set up a specified user on the system
- zabbix.yml: set up Zabbix monitoring for a server
- files/inst_pkg_opensuse.yml: set up basic software on a OpenSUSE desktop system
