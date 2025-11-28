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

# Check and Init Voms Proxy Init Atlas
irvpia() {
    setup_rucio() {
        # Check that we have the correct voms-proxy-init executable, which gets loaded by running 'lsetup rucio'
        # If not, setup rucio first.
        if ! command -v rucio &> /dev/null; then
            # Check if lsetup is available
            if ! which lsetup &> /dev/null; then
                setupATLAS
            fi
            lsetup rucio
        fi
    }

    local pass_file="$HOME/.private/gridcert.pass"
    local voms="atlas"
    local force_init="false"
   
    #------------------------------------------
    # Parse cmd line arguments
    #------------------------------------------
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -f|--file)
                pass_file="$2"
                shift 2
                ;;
            -p|--password)
                pass_file=""
                shift
                ;;
            -t|--trigger)
                voms="atlas:/atlas/trig-analysis/Role=production"
                shift
                ;;
            -v|--voms)
                voms="$2"
                shift 2
                ;;
            -r|--renew)
                force_init="true"
                shift
                ;;
            -h|--help)
                echo "Usage: irvpia [-f|--file FILE] [-p|--password] [-t|--trigger] [-v|--voms VOMS] [-r|--renew]"
                echo
                echo "VOMS proxy initializer."
                echo "Uses the 'atlas' VOMS role by default."
                echo
                echo "Options:"
                echo "  -f, --file FILE         Use the specified password file instead of \$HOME/.private/gridcert.pass."
                echo "  -p, --password          Use a different password provided at runtime."
                echo "  -t, --trigger           Use the trig-analysis production VOMS role (and force a renewal if an existing proxy is valid)."
                echo "  -v, --voms              Use a custom VOMS role (and force a renewal if an existing proxy is valid)."
                echo "  -r, --renew             Force renew the VOMS proxy, even if it has more than 1h lifetime remaining."
                echo "  -h, --help              Show this help message and exit."
                echo
                return 0
                ;;
            --) # stop parsing
                shift
                break
                ;;
            -*)
                echo "irvpia: unknown option: $1" >&2
                return 1
                ;;
            *)
                echo "irvpia: unknown argument: $1" >&2
                return 1
                ;;
        esac
    done
   
    # Check if the password file exists, if we're using one
    if [[ ! -z "$pass_file" ]]; then
        if [[ ! -f "$pass_file" ]]; then
            echo "The indicated password file '${pass_file}' does not exist. Defaulting to a user-provided password instead."
            pass_file=""
        fi
   
        if [[ ! -z "$pass_file" ]]; then
            # Check that the file has the correct permissions
            local current_perm=$(stat -c %a "$pass_file")
            if [[ "$current_perm" != "400" ]]; then
                echo "The password file MUST only be readable (and only readable!) by YOU."
                echo "Run '$ chmod 400 $pass_file'"
                echo "to fix it before continuing."
                return 1
            fi
        fi
    fi
   
    # Check if we already have a valid ticket with the correct roles
    if [[ "$voms" == "atlas" && "$force_init" == "false" && -e "/tmp/x509up_u${UID}" ]]; then
        # Check if we have *any* version of voms-proxy-info available
        if ! command -v voms-proxy-info &> /dev/null; then
            setup_rucio
        fi
   
        # Run the command and capture the output
        local cmd_out=$(voms-proxy-info)
   
        # Extract the "timeleft" field using awk
        local timeleft=$(echo "$cmd_out" | awk '/timeleft/ {print $3}')
   
        # Split the timeleft field into hours, minutes, and seconds
        IFS=":" read -r hours minutes seconds <<< "$timeleft"
   
        # Calculate the remaining time in seconds
        local remaining_time=$((hours * 3600 + minutes * 60 + seconds))
   
        # Check if remaining time is less than 1 hour (3600 seconds)
        if ((remaining_time >= 3600)); then
            return 0
        elif ((remaining_time > 0)); then
            echo "Renewing VOMS proxy (< 1h remaining)"
        fi
    fi
   
    # Load the correct voms-proxy-init version
    setup_rucio
   
    # Initialize VOMS proxy
    if [[ -z "$pass_file" ]]; then
        voms-proxy-init -voms "$voms"
    else
        cat "$pass_file" | voms-proxy-init -voms "$voms"
    fi
}

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
    if ! which pbook &> /dev/null; then
        lsetup panda
    fi
    irvpia
}

# Setup Rucio Panda / Panda Rucio
# (we implement it manually again to keep irvpia at the end)
srp() {
    sa
    local pkgs=()
    if ! which rucio &> /dev/null; then pkgs+=("rucio"); fi
    if ! which pbook &> /dev/null; then pkgs+=("panda"); fi
    if [[ ${#pkgs[@]} != 0 ]]; then lsetup $pkgs[@]; fi
    irvpia
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

