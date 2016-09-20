#!/bin/bash

# VPN Kill Switch
# Turn it off script :P
# 

iptables -F
iptables -A INPUT -j ACCEPT
iptables -A OUTPUT -j ACCEPT
