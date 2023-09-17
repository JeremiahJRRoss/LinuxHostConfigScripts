# Script Directory


## Securing your Linux Host 

### Create TLS certificates with Let's Encrypt and confgure Auto Renew

#### CentOS9:

[TLSCertCreate-and-AutoRenew_CentOS9_LetsEncrypt.sh](https://github.com/JeremiahJRRoss/LinuxHostConfigScripts/blob/main/TLSCertCreate-and-AutoRenew_CentOS9_LetsEncrypt.sh)
>What it does: Create & automate renewal of TLS certs using Let's Encrypt on a CentOS9 Host
>
>Description: This script will install certs from Let's Encrypt, copy them to a directory in /opt/ for use by other applications, create a script in /opt to update the certs, and then update crontab to run that script daily.
>
>Optional Pre-Script:You can create a new application user by uncommenting lines in the optional pre-script
>


### Configure Firewalld: Create a new zone, add port rules, apply the zone to an interface

#### CentOS9, RHEL9, Fedora 

[Firewalld_Create-and-Apply-Zone-with-Ports.sh](https://github.com/JeremiahJRRoss/LinuxHostConfigScripts/blob/main/Firewalld_Create-and-Apply-Zone-with-Ports.sh)
>What it does: Create a new zone, creates rules that open ports for UDP & TCP, applies a zone to an interface
>
>Description: This script will loop through a series of ports and interfaces to create a firewalld zone with ports. It will then apply your new zone to specified interfaces
>


## Installing commonly used applications

### Install a Cribl Stream Leader

#### CentOS9:

[Install-Cribl-Leader_CentOS9.sh](https://github.com/JeremiahJRRoss/LinuxHostConfigScripts/blob/main/Install-Cribl-Leader_CentOS9.sh)
>What it does: Install a Cribl Stream Leader using Cribl's latest Linux package
>
>Description: This script will create a user to run Cribl, install cribl, apply permissions, configure systemd to enable cribl, and then start cribl
>
