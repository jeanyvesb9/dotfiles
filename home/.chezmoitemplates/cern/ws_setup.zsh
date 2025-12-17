# CERN local zsh config file to interact with LXPlus (and similar nodes), by Jean Yves Beaucamp - 2025.

export CERN_USERNAME="jbeaucam"

# Add CERN-specific scripts
export PATH="$HOME/.local/bin/cern_ws:$PATH"

# Get OTP passwords
# This uses pass-otp (https://github.com/tadfisher/pass-otp)
# Before running the first time, you'll need to have a GPG secret key:
#
# $ gpg --full-generate-key # Use all the default options
#
# If you're using a YubiKey, follow the instructions in 
# https://support.yubico.com/s/article/Using-Your-YubiKey-with-OpenPGP
# to generate a key locked by your 2FA hardware key.
#
# Now, get the uid for your created key from
#
# $ gpg --list-keys
#
# and use that uid to initialize the pass keychain storage, e.g.
#
# $ pass init "Jean Yves Beaucamp <jeanyvesb9@gmail.com>"
#
# Finally, insert the secret otpauth SHA1 keys for the CERN accounts
#
# $ pass otp insert cern-jbeaucam <otpauth-jbeaucam>
# $ pass otp insert cern-jyb <otpauth-jyb>
#
# The keys can be found in ~/Dropbox/cern/private/otp_secret_keys.txt

alias otp-jbeaucam="pass otp cern-jbeaucam"
alias otp-jyb="pass otp cern-jyb"

alias lxtunnel="lxp lxtunnel"
alias lxtunnelcm="lxp --cm lxtunnel"
alias lxtunnelcme="lxpc --cm-exit lxtunnel"

alias lxproxy="lxp -p"
alias lxvnc="lxp -v"

export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
alias setupATLAS='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'

