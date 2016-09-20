#!/bin/bash

# VPN KillSwitch Script
# Based off scripts from the internet - edited and customised and consolidated
# v0.1 by Mark C.

# Flush
iptables -F
iptables -t nat -F
iptables -t mangle -F

# Flush V6
ip6tables -F
ip6tables -t nat -F
ip6tables -t mangle -F

# Local
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Local V6
ip6tables -A INPUT -i lo -j ACCEPT
ip6tables -A OUTPUT -o lo -j ACCEPT

# Make sure you can communicate with DHCP server
iptables -A OUTPUT -d 255.255.255.255 -j ACCEPT
iptables -A INPUT -s 255.255.255.255 -j ACCEPT

# Make sure that you can communicate within your own network if Private Network option is enabled
# Enable all RFC1918 address spaces
iptables -A INPUT -s 10.0.0.0/8 -d 10.0.0.0/8 -j ACCEPT
iptables -A OUTPUT -s 10.0.0.0/8 -d 10.0.0.0/8 -j ACCEPT
iptables -A INPUT -s 192.168.0.0/16 -d 192.168.0.0/16 -j ACCEPT
iptables -A OUTPUT -s 192.168.0.0/16 -d 192.168.0.0/16 -j ACCEPT
iptables -A INPUT -s 172.16.0.0/12 -d 172.16.0.0/12 -j ACCEPT
iptables -A OUTPUT -s 172.16.0.0/12 -d 172.16.0.0/12 -j ACCEPT

# Allow incoming pings if Ping option is enabled
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT

# Allow established sessions to receive traffic:
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow VPN traffic:
iptables -I OUTPUT 1 -d <VPN-SERVER-IP> -j ACCEPT
iptables -D OUTPUT -d <VPN-SERVER-IP> -j ACCEPT
# Copy these rules for any specific server you want exeternal pass-thru for...

# Allow TUN
iptables -A INPUT -i tun+ -j ACCEPT
iptables -A FORWARD -i tun+ -j ACCEPT
iptables -A OUTPUT -o tun+ -j ACCEPT

# Block All
iptables -A OUTPUT -j DROP
iptables -A INPUT -j DROP
iptables -A FORWARD -j DROP

# Block All V6
ip6tables -A OUTPUT -j DROP
ip6tables -A INPUT -j DROP
ip6tables -A FORWARD -j DROP
