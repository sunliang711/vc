{
    "inbound": {
        "port": 1082,
        "protocol": "socks",
        "domainOverride": [
            "tls",
            "http"
        ],
        "settings": {
            "auth": "noauth"
        }
    },
    "log": {
        "loglevel": "info"
    },
    "outbound": {
        "protocol": "vmess",
        "settings": {
            "vnext": [
                {
                    "address": "g2.eagle711.win",
                    "port": 8900,
                    "users": [
                        {
                            "afterId": 64,
                            "id": "e2791dbb-f340-4a71-998a-da3b184a1cef",
                            "level": 1
                        }
                    ]
                }
            ]
        },
        "streamSettings": {
            "network": "ws"
        }
    },
    "outboundDetour": [
        {
            "protocol": "freedom",
            "settings": {},
            "tag": "direct"
        },
        {
            "protocol": "blackhole",
            "settings": {},
            "tag": "adblock"
        }
    ],
    "routing": {
        "strategy": "rules",
        "settings": {
            "domainStrategy": "IPIfNonMatch",
            "rules": [
                {
                    "domain": [
                        "ad.com"
                    ],
                    "type": "field",
                    "outboundTag": "adblock"
                },
                {
                    "domain": [
                        "qq.com"
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
            ]
        }
    }
}
