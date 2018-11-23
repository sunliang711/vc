#!/bin/bash
root="$(cd $(dirname $BASH_SOURCE) && pwd)"

user="${SUDO_USER:-$(whoami)}"
home="$(eval echo ~$user)"

function usage(){
    cat <<-EOF
	Usage: $(basename $0) cmd
	cmd:
	    install
	    uninstall
	EOF
}

function check(){
    if (($EUID!=0));then
        echo "Need run as root"
        exit 1
    fi
}

function install(){
    check
    sed -e "s|USER|$user|g" -e "s|ROOT|$root|g" v2ray-socks.service > /etc/systemd/system/v2ray-socks.service
    sed -e "s|USER|$user|g" -e "s|ROOT|$root|g" v2ray-router.service > /etc/systemd/system/v2ray-router.service

    systemctl enable v2ray-socks
    systemctl enable v2ray-router

    ln -sf $root/v22.sh /usr/local/bin
}

function uninstall(){
    check
    rm /etc/systemd/system/v2ray-socks.service
    rm /etc/systemd/system/v2ray-router.service
    rm /usr/local/bin/v22.sh
}

cmd=$1
case $cmd in
    install)
        install
        ;;
    uninstall)
        uninstall
        ;;
    *)
        usage
        ;;
esac

