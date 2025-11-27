# CERN LXPlus (and similar nodes) zsh config file, by Jean Yves Beaucamp - 2025.

# Envionment setup ------------------------------------------------------------
# TestBed machines: ----------------------------
if [[ $HOSTNAME == *pc-tbed-* ]]; then
    export SITE_NAME=CERN-PROD
    export ATHENA_CORE_NUMBER=`nproc`
    export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
    alias setupATLAS='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'

    alias cs='cd /scratch/jbeaucam'
    alias ms='mkdir -p /scratch/jbeaucam'
fi

# Containers -----------------------------------
if [[ ! -z ${APPTAINER_NAME+x} && $APPTAINER_NAME == "x86_64-centos7" ]]; then
    # Add the setupATLAS alias in containers 
    export ATLAS_LOCAL_ROOT_BASE=/cvmfs/atlas.cern.ch/repo/ATLASLocalRootBase
    alias setupATLAS='source ${ATLAS_LOCAL_ROOT_BASE}/user/atlasLocalSetup.sh'
fi

# Start a CentOS 7 container
alias c7c='setupATLAS -c centos7'



# General shortcuts -----------------------------------------------------------

# Print node session history
alias hh='tail ~/.hostname_history'

# Delete VSCode lockfiles
alias crl="rm -f $HOME/.vscode-server/code-*"

# setupATLAS
sa() {
    # Setup the common ATLAS environment if "lsetup is not there already"
    if ! which lsetup &> /dev/null; then
        setupATLAS
    fi
}

# Setup Rucio
sr() {
    sa
    if ! which rucio &> /dev/null; then
        lsetup rucio
    fi
    irvpia
}

# Setup Panda
sp() {
    sa
    if ! which panda &> /dev/null; then
        lsetup panda
    fi
    irvpia
}

# Setup Rucio Panda / Panda Rucio
srp() {
    sr
    sp
}
alias spr="srp"

# Setup Git
sg() {
    sa
    lsetup git
}

# Setup PMG's centralpage util
sctrlp() {
    sa
    if ! which centralpage &> /dev/null; then
        lsetup centralpage
    fi
    irvpia
}

# Setup standalone LCG release
slcg() {
    RECOMMENDED_LCG="LCG_108"
    RECOMMENDED_LCG_PLATFORM_EL9="x86_64-el9-gcc15-opt"

    sa
    lsetup "views ${RECOMMENDED_LCG} ${RECOMMENDED_LCG_PLATFORM_EL9}"
}

# Initialize VNC server for remote connection
vncs() {
    local default_display=7
    local geometry="1280x880"

    if [[ -z "$1" ]]; then
        vncserver -geometry $geometry :$default_display
    elif [[ "$1" =~ ^[0-9]+$ ]] && (( $1 >= 0 && $1 <= 100 )); then
        vncserver -geometry $geometry :$1
    else
        echo "Usage: vncs [display_number (0-100)]"
        return 1
    fi
}



# Kerberos --------------------------------------------------------------------
kerbInit(){
    kinit -k -t ~/.keytab jbeaucam@CERN.CH
}

ktmux(){
    if [[ -z "$1" ]]; then #if no argument passed
        k5reauth -f -i 3600 -p jbeaucam -k /afs/cern.ch/user/j/jbeaucam/.keytab -- tmux new-session
    else #pass the argument as the tmux session name
        k5reauth -f -i 3600 -p jbeaucam -k /afs/cern.ch/user/j/jbeaucam/.keytab -- tmux new-session -s $1
    fi
}



# TDAQ ------------------------------------------------------------------------
alias setupTT='source /afs/cern.ch/user/a/attrgcnf/TriggerTool/Run3/current/installed/setup.sh'
alias setupTDAQ='source /cvmfs/atlas.cern.ch/repo/sw/tdaq/tools/cmake_tdaq/bin/cm_setup.sh tdaq-12-00-00'

# TestBed access
tbedp() {
    address="pc-tbed-pub"
    if [[ $# -eq 1 ]]; then
        if [[ $1 =~ ^[0-9]+$ ]]; then
            # If the number has one digit, prepend a 0
            if [[ "${#1}" == 1 ]]; then
                address="${address}-0$1"
            else
                address="${address}-$1"
            fi
        else
            echo "Error: Argument is not a valid number."
            return 1
        fi
    fi
    ssh "$address"
}



# Point 1 ---------------------------------------------------------------------
alias atlasgw='ssh atlasgw'


# Git -------------------------------------------------------------------------
alias gaiw='git atlas init-workdir ssh://git@gitlab.cern.ch:7999/jbeaucam/athena.git'



# LaTeX -----------------------------------------------------------------------
export PATH="/cvmfs/sft.cern.ch/lcg/external/texlive/2025/bin/x86_64-linux:$PATH"

