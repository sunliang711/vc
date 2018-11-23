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
    if (($EUID==0));then
        echo "Don't run as root"
        exit 1
    fi
}

function install(){
    check
    case $(uname) in
        Linux)
            cmds=$(cat<<-EOF
            sed -e "s|USER|$user|g" -e "s|ROOT|$root|g" $(uname)/v2ray-socks.service > /etc/systemd/system/v2ray-socks.service
            sed -e "s|USER|$user|g" -e "s|ROOT|$root|g" $(uname)/v2ray-router.service > /etc/systemd/system/v2ray-router.service

			systemctl enable v2ray-socks
			systemctl enable v2ray-router

			ln -sf $root/v22.sh /usr/local/bin
EOF
)
            sudo -- sh -c "$cmds"
            ;;
        Darwin)
            sed -e "s|ROOT|$root|g" $(uname)/v2ray-router.plist > $home/Library/LaunchAgents/v2ray-router.plist
            sed -e "s|ROOT|$root|g" $(uname)/v2ray-socks.plist > $home/Library/LaunchAgents/v2ray-socks.plist
            ln -sf "$root/v22.sh" /usr/local/bin
            ;;
    esac
}

function uninstall(){
    check
    case $(uname) in
        Linux)
            cmds=$(cat<<-EOF
				systemctl stop v2ray-socks.service
				systemctl stop v2ray-router.service
				systemctl disable v2ray-socks.service
				systemctl disable v2ray-router.service
				rm /etc/systemd/system/v2ray-socks.service
				rm /etc/systemd/system/v2ray-router.service
				rm /usr/local/bin/v22.sh
				EOF
)
            sudo -- sh -c "$cmds"
            ;;
        Darwin)
            rm $home/Library/LaunchAgents/v2ray-router.plist
            rm $home/Library/LaunchAgents/v2ray-socks.plist
            rm /usr/local/bin/v22.sh
            ;;
    esac
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

