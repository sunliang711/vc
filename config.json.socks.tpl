{
    "inbound": {
        "port": 1081,
        "protocol": "socks",
        "domainOverride":["tls","http"],
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
        "streamSettings":{
            "network":"ws"
        }
    }
}
