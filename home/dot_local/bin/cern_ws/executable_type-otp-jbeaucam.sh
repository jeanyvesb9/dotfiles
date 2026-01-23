#!/bin/bash

# Wait half a second for the user to stop pressing the shortcut
sleep 0.5
# Insert the OTP
ydotool type --escape=0 "$(pass otp cern-jbeaucam)"
