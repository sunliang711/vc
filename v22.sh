#!/bin/bash
rpath="$(readlink $BASH_SOURCE)"
if [ -z "$rpath" ];then
    rpath="$BASH_SOURCE"
fi

root="$(cd $(dirname $rpath) && pwd)"
cd "$root"

editor=vi
if command -v vim >/dev/null 2>&1;then
    editor=vim
fi

user=${SUDO_USER:-$(whoami)}
home=$(eval echo ~$user)

routerCfg=config.json.router
socksCfg=config.json.socks
function usage(){
    cat<<-EOF
Usage: $(basename $0) cmd
cmd:
    start
    stop
    restart
    status
    cr (config router config)
    cs (config socks config)
EOF
}

function start(){
    if [ ! -e $routerCfg ];then
        echo "Run cr to config"
        exit 1
    fi
    if [[ ! -e "$socksCfg" ]];then
        echo "Run cs to config"
        exit 1
    fi
    case $(uname) in
        Linux)
            sudo systemctl start v2ray-socks.service
            sudo systemctl start v2ray-router.service
            ;;
        Darwin)
            launchctl load $home/Library/LaunchAgents/v2ray-socks.plist
            launchctl load $home/Library/LaunchAgents/v2ray-router.plist
            ;;
    esac
}

function stop(){
    case $(uname) in
        Linux)
            sudo systemctl stop v2ray-socks.service
            sudo systemctl stop v2ray-router.service
            ;;
        Darwin)
            launchctl unload $home/Library/LaunchAgents/v2ray-socks.plist
            launchctl unload $home/Library/LaunchAgents/v2ray-router.plist
            ;;
    esac
}

function status(){
    case $(uname) in
        Linux)
            systemctl status v2ray-socks.service
            systemctl status v2ray-router.service
            ;;
        Darwin)
            echo "TODO"
            ;;
    esac
}

function cr(){
    $editor block
    $editor direct
    #config router
    python makeRouter.py
    $editor $routerCfg
}

function cs(){
    if [ ! -e "$socksCfg" ];then
        cp "${socksCfg}.tpl" $socksCfg
    fi
    #config socks
    $editor $socksCfg
}

cmd=$1
case "$cmd" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        status
        ;;
    cr)
        cr
        ;;
    cs)
        cs
        ;;
    *)
        usage
        ;;
esac
