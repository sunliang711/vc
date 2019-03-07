{
    "inbound": {
        "domainOverride": [
            "tls", 
            "http"
        ], 
        "protocol": "socks", 
        "port": 1082, 
        "settings": {
            "auth": "noauth"
        }
    }, 
    "outboundDetour": [
        {
            "tag": "direct", 
            "protocol": "freedom", 
            "settings": {}
        }, 
        {
            "tag": "adblock", 
            "protocol": "blackhole", 
            "settings": {}
        }
    ], 
    "outbound": {
        "streamSettings": {
            "network": "ws"
        }, 
        "protocol": "vmess", 
        "settings": {
            "vnext": [
                {
                    "address": "g2.eagle711.win", 
                    "users": [
                        {
                            "afterId": 64, 
                            "id": "e2791dbb-f340-4a71-998a-da3b184a1cef", 
                            "level": 1
                        }
                    ], 
                    "port": 8900
                }
            ]
        }
    }, 
    "log": {
        "loglevel": "info"
    }, 
    "routing": {
        "strategy": "rules", 
        "settings": {
            "rules": [
                {
                    "domain": [
                        "ad.com", 
                        "ad1.com", 
                        "ad2.com", 
                        "ad3.com", 
                        "ad4.com", 
                        "ad5.com"
                    ], 
                    "type": "field", 
                    "outboundTag": "adblock"
                }, 
                {
                    "domain": [
                        "qq.com", 
                        "baidu.com", 
                        "dircet1.com", 
                        "direct2.com", 
                        "qq.com", 
                        "jd.com"
                    ], 
                    "type": "field", 
                    "outboundTag": "direct"
                }, 
                {
                    "type": "chinasites", 
                    "outboundTag": "direct"
                }, 
                {
                    "type": "chinaip", 
                    "outboundTag": "direct"
                }
            ], 
            "domainStrategy": "IPIfNonMatch"
        }
    }
}