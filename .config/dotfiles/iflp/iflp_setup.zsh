# IFLP zsh config file, by Jean Yves Beaucamp - 2025.

if [[ "$__HOST_IS_OFFICE" = true ]]; then
    alias mount-r5='sshfs jbeaucamp@163.10.100.39:/mnt/R5 /media/R5 -o allow_other'
elif [[ "$__HOST_IS_PRIV" = true ]]; then
    alias vpn-clust="sudo openvpn $HOME/Dropbox/IFLP/Setup/cluster_gw2-UDP4-1194-Jean/gw2-UDP4-1194-Jean.ovpn"
fi

alias clust='ssh -Y jbeaucamp@163.10.100.39'
