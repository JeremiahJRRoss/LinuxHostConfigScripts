# Script Directory

## Securing your Linux Host 

#### Create TLS certificates with Let's Encrypt and confgure Auto Renew
##### CentOS9
**TLSCertCreate-and-AutoRenew_CentOS9_LetsEncrypt.sh **
```
What it does: Create & automate renewal of TLS certs using Let's Encrypt on a CentOS9 Host

Description: This script will install certs from Let's Encrypt, copy them to a directory in /opt/ for use by other applications, create a script in /opt to update the certs, and then update crontab to run that script daily.

Optional Pre-Script: There is also an option to create a new application user, if uncomment lines in the pre-script section. 
```
