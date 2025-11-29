# Copyright (C) 2025 Jean Yves Beaucamp
# CERN LXPlus (and similar nodes) zsh paths config
# These need to be loaded at the beginning of .zshrc, before we start checking for
# existing scripts/programs to add aliases

# Source global definitions
if [ -f /etc/zshrc ]; then
    . /etc/zshrc
fi


# OS-Specific configuration
. /etc/os-release
os_local_path=""
if [[ $ID == "centos" && $VERSION_ID == 7* ]]; then
    os_local_path="centos7"
elif [[ ($ID == "rhel" || $ID == "almalinux") && $VERSION_ID == 9* ]]; then
    os_local_path="el9"
fi

if [[ ! -z "$os_local_path" ]]; then
    export PATH="$HOME/.local/${os_local_path}/bin:$PATH"
    export LD_LIBRARY_PATH="$HOME/.local/${os_local_path}/lib:$HOME/.local/${os_local_path}/lib64:$LD_LIBRARY_PATH"
    export LD_RUN_PATH="$HOME/.local/${os_local_path}/lib:$HOME/.local/${os_local_path}/lib64:$LD_RUN_PATH"
fi
