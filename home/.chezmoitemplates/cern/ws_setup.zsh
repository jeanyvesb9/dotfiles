# CERN local zsh config file to interact with LXPlus (and similar nodes), by Jean Yves Beaucamp - 2025.

export CERN_USERNAME="jbeaucam"

# Add CERN-specific scripts
export PATH="$HOME/.local/bin/cern_ws:$PATH"

# LXPlus session manager scripts and aliases
export PATH="$HOME/.local/bin/lxp-session-manager/scripts:$PATH"

alias lxtunnel="lxp lxtunnel"
alias lxtunnelcm="lxp --cm lxtunnel"
alias lxtunnelcme="lxpc --cm-exit lxtunnel"

alias lxproxy="lxp -p"
alias lxvnc="lxp -v"

# The GPG otpauth master keys can be found in ~/Dropbox/cern/private/otp_secret_keys.txt
# The installation instructions are in the lxp-session-manager README.md
alias otp-jbeaucam="pass otp cern-jbeaucam"
alias otp-jyb="pass otp cern-jyb"

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
alias setupATLAS='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'

