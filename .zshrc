# zsh config file, by Jean Yves Beaucamp - 2025.

### Config version ### -------------------------------------------------------------
# I need to enable/disable some options to run these dotfiles on all my devices

host=$(hostname)
if [[ "$(uname)" == "Linux" ]]; then
    export __HOST_IS_LINUX=true
    export __HOST_IS_MACOS=false
elif [[ "$(uname)" == "Darwin" ]]; then
    export __HOST_IS_LINUX=false
    export __HOST_IS_MACOS=true
fi

export __HOST_IS_CERN=$([[ "$host" == *.cern.ch ]] && echo true || echo false)
export __HOST_IS_PRIV=$([[ "$__HOST_IS_CERN" == "true" ]] && echo false || echo true)
export __HOST_IS_IFLP=$([[ "$host" == JeanYves-Office ]] && echo true || echo false)



### GENERAL ### --------------------------------------------------------------------

export TERM="xterm-256color"                      # getting proper colors
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export VISUAL="vim"
export EDITOR="vim"



### PATHS ### ----------------------------------------------------------------------
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:/usr/local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:$HOME/.local/lib64:$LD_LIBRARY_PATH"
export LD_RUN_PATH="$HOME/.local/lib:$HOME/.local/lib64:$LD_RUN_PATH"

# Load local Rust cargo environment (if available)
if [[ -f $HOME/.cargo/env ]]; then
    . "$HOME/.cargo/env"
fi

# Go install location
if [[ -d "$HOME/.local/go" ]]; then
    export GOPATH="$HOME/.local/go"
    export GOBIN="$HOME/.local/bin"
fi

# CERN LXPlus OS-specific paths
if [[ "$__HOST_IS_CERN" = true ]]; then
    source "$HOME/.dotfiles/dotfiles/cern/lxp_paths_setup.zsh"
fi



### Global TMux session ### --------------------------------------------------------
if [[ "$__HOST_IS_PRIV" = true ]]; then
    if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] \
            && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
        exec tmux new-session -A -s main
    fi
fi



### OH MY ZSH ### ------------------------------------------------------------------
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Add wisely, as too many plugins slow down shell startup.
plugins=(command-not-found
         history     
         git
         zsh-interactive-cd)

# Sourcing oh-my-zsh
# Your plugins will not work without this source.
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Fish-like syntax highlighting and autosuggestions
if [[ "$__HOST_IS_PRIV" = true ]]; then
    if [[ "$__HOST_IS_LINUX" = true ]]; then
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
    elif [[ "$__HOST_IS_MACOS" = true ]]; then
        source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    fi
fi



### ALIASES ### --------------------------------------------------------------------

if [[ "$__HOST_IS_LINUX" = true ]]; then
    # Open ('a-la macOS')
    alias open='xdg-open'
fi

# Git alias for linux_config
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
# On first time, run:
#   $ config config --local status.showUntrackedFiles no

# vim
if command -v nvim &> /dev/null; then
    alias vim='nvim'
fi

# clipboard: use as a pipe destination
if [[ "$__HOST_IS_LINUX" = true ]]; then
    alias cb='xclip -selection c'
elif [[ "$__HOST_IS_MACOS" = true ]]; then
    alias cb='pbcopy'
fi

# broot
if [[ -f $HOME/.config/broot/launcher/bash/br ]]; then
    source "$HOME/.config/broot/launcher/bash/br"
    alias bs='br --sizes'
fi

# Changing "ls" to "eza"
if command -v eza &> /dev/null; then
    alias ls='eza --color=always --group-directories-first' # my preferred listing
    alias la='eza -a --color=always --group-directories-first' # all files and dirs
    alias ll='eza -l --icons --color=always --group-directories-first' # list
    alias lla='eza -la --icons --color=always --group-directories-first' # list all
    alias lt='eza -aT --color=always --group-directories-first' # tree listing
    alias l.='eza -a | egrep "^\."'
else
    echo "Install eza!"
fi

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Confirm before overwriting something
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'

# Add global progress info
alias rsyncp="rsync --info=progress2"

# Adding flags
alias df='df -h' # Human-readable sizes
alias free='free -m' # Show sizes in MB

if [[ "$__HOST_IS_LINUX" = true ]]; then
    # get error messages from journalctl
    alias jctl="journalctl -p 3 -xb"
fi

if [[ "$__HOST_IS_PRIV" = true ]]; then
    # Airplay receiver
    alias airplay='rpiplay -n "$(hostname)"'
fi

# TMux
alias ta='tmux a'

# SSH
if [[ "$__HOST_IS_MACOS" = true ]]; then
    # To skip the "LANG LC_*" warnings, we override the default macOS ssh config in /etc/ssh/ssh_config
    alias ssh='ssh -F ~/.ssh/config'
fi



### Custom functions ### -----------------------------------------------------------

## extract <file1> [<file2> ...] : extraction helper for common file formats:
SAVEIFS=$IFS # internal field separator
IFS=$(echo -en "\n\b")
function extract {
 if [ -z "$1" ]; then
    # Display usage if no parameters given
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar) unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)
                         unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace) unace x ./"$n"     ;;
            *)           echo "extract: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}
IFS=$SAVEIFS


## up <n> : execs "cd .." <n> times
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}


## array_contains <array> <elem> : checks if the array contains an element
array_contains () {
  local array="$1[@]"
  local seeking=$2
  local in=1
  for element in "${(@element)array}"; do
    if [[ $element == "$seeking" ]]; then
      in=0
      break
    fi
  done
  return $in
}



# LaTeX ----------------------------------------------------------------------------
if [[ "$__HOST_IS_CERN" = true ]]; then
    TEX_PATH='/cvmfs/sft.cern.ch/lcg/external/texlive/2025/bin/x86_64-linux'
else
    if [[ "$__HOST_IS_LINUX" = true ]]; then
        TEX_PATH='/usr/local/texlive/2025/bin/x86_64-linux'
    elif [[ "$__HOST_IS_MACOS" = true ]]; then
        TEX_PATH='/usr/local/texlive/2025/bin/universal-darwin'
    fi
fi
export PATH="$TEX_PATH:$PATH"



# CERN -----------------------------------------------------------------------------
export RUCIO_ACCOUNT=jbeaucam
export EOS_MGM_URL=root://eosuser.cern.ch

if [[ "$__HOST_IS_PRIV" = true ]]; then
    source $HOME/.dotfiles/dotfiles/cern/local_setup.zsh
elif [[ "$__HOST_IS_CERN" = true ]]; then
    source $HOME/.dotfiles/dotfiles/cern/lxp_setup.zsh
fi



# IFLP -----------------------------------------------------------------------------
if [[ "$__HOST_IS_PRIV" = true || "$__HOST_IS_OFFICE" = true ]]; then
    source $HOME/.dotfiles/dotfiles/iflp/iflp_setup.zsh
fi



### CONDA/MAMBA ### ----------------------------------------------------------------
# On the first time you should run
# $ conda config --set auto_activate_base false
# in order to prevent conda activation by default, and screwing with the defaut python shell

# We need to safeguard the conda/mamba initialization on CERN hosts
if [[ "$__HOST_IS_PRIV" = true ]]; then

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/jeany/mambaforge/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/jeany/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/home/jeany/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/home/jeany/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/jeany/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "/home/jeany/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

fi
