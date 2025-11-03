# CERN LXPlus (and similar nodes) zsh paths config file, by Jean Yves Beaucamp - 2025.

# Source global definitions
if [ -f /etc/zshrc ]; then
    . /etc/zshrc
fi


# OS-Specific configuration
. /etc/os-release
if [[ $ID == "centos" && $VERSION_ID == 7* ]]; then
    export PATH="$HOME/.local/centos7/bin:$PATH"
    export LD_LIBRARY_PATH="$HOME/.local/centos7/lib:$HOME/.local/centos7/lib64:$LD_LIBRARY_PATH"
    export LD_RUN_PATH="$HOME/.local/centos7/lib:$HOME/.local/centos7/lib64:$LD_RUN_PATH"
elif [[ ($ID == "rhel" || $ID == "almalinux") && $VERSION_ID == 9* ]]; then
    export PATH="$HOME/.local/el9/bin:$PATH"
    export LD_LIBRARY_PATH="$HOME/.local/el9/lib:$HOME/.local/el9/lib64:$LD_LIBRARY_PATH"
    export LD_RUN_PATH="$HOME/.local/el9/lib:$HOME/.local/el9/lib64:$LD_RUN_PATH"

    # TODO: Is this still needed?
    alias ssh='ssh -o RequiredRSASize=1024'
    alias scp='scp -o RequiredRSASize=1024'
fi
