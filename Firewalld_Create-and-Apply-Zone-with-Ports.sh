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

#---- Begin Script ----
## Create a new zone and add both ssh & dhcpv6-client 

sudo firewall-cmd --permanent --new-zone=$NewZone
sudo firewall-cmd --permanent --add-service=ssh --zone=$NewZone
sudo firewall-cmd --permanent --add-service=dhcpv6-client --zone=$NewZone

## now loop through the "PortsToOpen" array to add ports to your new zone

for i in "${PortsToOpen[@]}"
do
   sudo firewall-cmd --permanent --zone=$NewZone --add-port="$i"/tcp
   sudo firewall-cmd --permanent --zone=$NewZone --add-port="$i"/udp
done

## Configure your new zone to drop all packets not in this list of rules

sudo firewall-cmd --permanent --zone=$NewZone --set-target=DROP

## now loop through the "ZonedInterfaces" array to bind your new zone to the desired interfaces

for i in "${ZonedInterfaces[@]}"
do
sudo firewall-cmd --permanent --zone=$NewZone --change-interface=$i
done

## restart firewalld so that changes take effect
sudo systemctl restart firewalld.service

## print a list of all active zones
sudo firewall-cmd --get-active-zones

## print a list of the rules in your active zone 
sudo firewall-cmd --zone=$NewZone --list-all



