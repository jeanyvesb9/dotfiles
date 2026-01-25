#!/bin/bash

# For ydotool to run, the background daemon needs to be running. The default deamon service file
# installed by the aur package is misplaced to the user services directories. Moreover, the command
# needs to be modified. Here is a version of the service file that works as of 2026/01/25, to be
# located at /usr/lib/systemd/system/ydotool.service:
#
# [Unit]
# Description=Starts ydotoold service
# 
# [Service]
# Type=simple
# Restart=always
# ExecStart=/usr/bin/ydotoold --socket-path="/run/user/1000/.ydotool_socket" --socket-own="1000:1000"
# 
# ExecReload=/usr/bin/kill -HUP $MAINPID
# KillMode=process
# TimeoutSec=180
# 
# [Install]
# WantedBy=default.target


# Wait half a second for the user to stop pressing the shortcut
sleep 0.5
# Insert the OTP
ydotool type --escape=0 "$(pass otp cern-jbeaucam)"
