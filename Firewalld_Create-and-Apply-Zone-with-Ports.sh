#!/bin/bash

#---ABOUT THIS SCRIPT---

#Name: Firewalld_Create-and-Apply-Zone-with-Ports.sh

#What it does: Create a new zone, creates rules that open ports for UDP & TCP, applies a zone to an interface


#---- ENTER YOUR VARIABLES HERE - THESE ARE NOT OPTIONAL ----

##  --- CUSTOM VARIABLE 1 OF 3 -  Enter the name of your new zone

NewZone="StrawberryZone23"

##  --- CUSTOM VARIABLE 2 OF 3 - Enter the interface to which your new zone will be applied

declare -a ZonedInterfaces=("eth1")

##  --- CUSTOM VARIABLE 3 OF 3 - A space delimited array for the numbered ports that you would like opened
 
declare -a PortsToOpen=("514" "10020" "10030")

sudo firewall-cmd --permanent --new-zone=$NewZone

## now loop through the above array
for i in "${PortsToOpen[@]}"
do
   sudo firewall-cmd --permanent --zone=$NewZone --add-port="$i"/tcp
   sudo firewall-cmd --permanent --zone=$NewZone --add-port="$i"/udp
done

sudo firewall-cmd --permanent --zone=$NewZone --set-target=DROP
sudo firewall-cmd --permanent --zone=$NewZone --change-interface=$ZonedInterfaces
sudo systemctl restart firewalld.service
sudo firewall-cmd --get-active-zones
sudo firewall-cmd --zone=public --list-all

