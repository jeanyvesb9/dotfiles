# CERN local zsh config file to interact with LXPlus (and similar nodes), by Jean Yves Beaucamp - 2025.

export CERN_USERNAME="jbeaucam"

# Add CERN-specific scripts
export PATH="$HOME/.local/bin/cern_ws:$PATH"

# Get OTP passwords
# This uses pass-otp (https://github.com/tadfisher/pass-otp)
# Before running the first time, you'll need to have a GPG secret keychain, which you
# can initialize with $ gpg --full-generate-key.
# Requires having the OTP secret keys already loaded in your local GPG keychain
# They can be found in ~/Dropbox/cern/private/otp_secret_keys.txt
alias otp-jbeaucam="pass otp cern-jbeaucam"
alias otp-jyb="pass otp cern-jyb"

alias lxtunnel="lxp lxtunnel"
alias lxtunnelcm="lxp --cm lxtunnel"
alias lxtunnelcme="lxpc --cm-exit lxtunnel"

alias lxproxy="lxp -p"
alias lxvnc="lxp -v"

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
alias setupATLAS='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'

