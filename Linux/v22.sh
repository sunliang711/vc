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

cmd=$1
case "$cmd" in
    start)
        if [ ! -e $routerCfg ];then
            echo "Run cr to config"
            exit 1
        fi
        if [[ ! -e "$socksCfg" ]];then
            echo "Run cs to config"
            exit 1
        fi
        sudo systemctl start v2ray-socks.service
        sudo systemctl start v2ray-router.service
        ;;
    stop)
        sudo systemctl stop v2ray-socks.service
        sudo systemctl stop v2ray-router.service
        ;;
    restart)
        sudo systemctl restart v2ray-socks.service
        sudo systemctl restart v2ray-router.service
        ;;
    status)
        systemctl status v2ray-socks.service
        systemctl status v2ray-router.service
        ;;
    cr)
        $editor block
        $editor direct
        #config router
        python makeRouter.py
        $editor $routerCfg
        ;;
    cs)
        if [ ! -e "$socksCfg" ];then
            cp "${socksCfg}.tpl" $socksCfg
        fi
        #config socks
        $editor $socksCfg
        ;;
    *)
        usage
        ;;
esac
