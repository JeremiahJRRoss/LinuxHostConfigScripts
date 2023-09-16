#!/bin/bash

#---ABOUT THIS SCRIPT---

#Name: TLSCertCreate-and-AutoRenew_CentOS9_LetsEncrypt.sh

#What it does: Create & automate renewal of TLS certs using Let's Encrypt on a CentOS9 Host

#Description: This script will install certs from Let's Encrypt, copy them to a directory in /opt/ for use by other applications, create a script in /opt to update the certs, and then update crontab to run that script daily. 

#Optional Pre-Script: There is also an option to create a new application user, if uncomment lines in the pre-script section. 

#---REQUIREMENTS---

## Make sure that your DNS record points to the IP of your machine

## Make sure that ports 80 and 443 are open on your network firewall or cloud service provider's security group

## If using NAT, make sure that NAT is forwarding ports 80 and 443 to the local IP adress of your host

## Run this script as a priviledged user. If not root, be sure to add sudo to the command

#--- HOW TO CREATE AND RUN THIS SCRIPT ---

### cd /opt

### sudo vi TLSCertCreate-and-AutoRenew_CentOS9_LetsEncrypt.sh
### (Enter into edit mode - you may do this by hitting the "a" key once)
### (Copy this script into VI after entering into edit mode - be sure not to accidentally add any characters to the script)
### (Update the variables in this script or you will have a bad time) 
### (Hit the escape key to exit out of edit mode - be sure not to accidentally add any characters to the script)
### (Close vi and save by typing ":wq")

### sudo chmod +x TLSCertCreate-and-AutoRenew_CentOS9_LetsEncrypt.sh
### sudo ./TLSCertCreate-and-AutoRenew_CentOS9_LetsEncrypt.sh

#---- ENTER YOUR VARIABLES HERE - THESE ARE NOT OPTIONAL ----

##  --- CUSTOM VARIABLE 1 OF 5 - ENTER YOUR FQDN HERE. Let's Encrypt will verify this DNS record when creating certs. Your certs will specify this domain the CN ---
LEfqdn="subdomain.domain.tld"

##  --- CUSTOM VARIABLE 2 OF 5 - ENTER YOUR APPLICATION NAME HERE. Your certs will be stored in /opt/cert-store/$AppDirName ---
AppDirName="CustomDirName"

##  --- CUSTOM VARIABLE 3 OF 5 - ENTER YOUR EMAIL HERE. Let's Encrypt will associate this email with your certs ---
CertEmail="you@domain.tld"

##  --- CUSTOM VARIABLE 4 OF 5 - ENTER YOUR APP USER HERE. This is the name of the system user that will run the application processes. We will assign ownership of the cert directory to this user ---
AppUser="NameofLinuxUser"

##  --- CUSTOM VARIABLE 5 OF 5 - ENTER YOUR SYSTEMD SERVICE NAME HERE. This is the name of the service that systemd will reference when restarting after the certs are updated ---
SystemDServiceName="servicename.service"

#--- OPTIONAL PRE-SCRIPTING SECTION ---

##PRE-SCRIPT: Uncomment the following line if you want to create your app user 
# sudo adduser $AppUser

##PRE-SCRIPT: Uncomment the following line if you want to add your App User to the sudo group (wheel)
# sudo usermod -aG wheel $AppUser

#--- THE ACTUAL SCRIPT ---

## install epel-release & certbot
yes | sudo dnf install epel-release -y
yes | sudo dnf install certbot -y

## run certbot to verify your DNS record and create a cert
sudo certbot certonly --standalone --agree-tos --email "$CertEmail" --noninteractive -d $LEfqdn

## create a directory to store your certs
sudo mkdir /opt/cert-store
sudo mkdir /opt/cert-store/$AppDirName

## copy your new certs into you application's cert directory
yes | cp /etc/letsencrypt/live/$LEfqdn/* /opt/cert-store/$AppDirName/

## make a new directory and create a script that will update the cert
## This script will include your fqdn in the name so that you know what it does 6 months from now
## This also prevents conflicts if you are managing multiple certs on the same Linux host (e.g. if you are using nginx or apache as a reverse proxy)
sudo mkdir /opt/script-store
sudo echo "#!/bin/bash
      certbot renew --quiet
      yes | cp /etc/letsencrypt/live/$LEfqdn/* /opt/cert-store/$AppDirName/
      chown -R $AppUser:$AppUser /opt/cert-store/$AppDirName
      systemctl restart $SystemDServiceName" > /opt/script-store/cert-renew_$LEfqdn.sh

## make the new cert executable
sudo chmod +x /opt/script-store/cert-renew_$LEfqdn.sh

## create a crontab rule that runs the aforementioned script every day 
(crontab -l 2>/dev/null; echo "0 0 * * * bash /opt/script-store/$LEfqdn.sh") | crontab -
