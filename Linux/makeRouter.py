#!/usr/bin/env python
import json
import os

configTpl = "config.json.router.tpl"
tmp="config.json.tmp"
configRouter = "config.json.router"

def addBlock(*urls):
    with open(configTpl) as f:
        data = f.read()

    js = json.loads(data)
    block = js['routing']['settings']['rules'][0]['domain']
    print("current blocks: {}".format(block))
    print("to be append urls: {}".format(urls))

    for url in urls:
        block.append(url)
    print("after append: {}".format(block))
    with open(tmp,'w') as f:
        f.write(json.dumps(js,indent=4))

def addDirect(*urls):
    with open(tmp) as f:
        data = f.read()

    js = json.loads(data)
    direct = js['routing']['settings']['rules'][1]['domain']
    print("current directs: {}".format(direct))
    print("to be append urls: {}".format(urls))

    for url in urls:
        direct.append(url)
    print("after append: {}".format(direct))
    with open(configRouter,'w') as f:
        f.write(json.dumps(js,indent=4))
    os.remove(tmp)

def getBlocks():
    with open('block') as f:
        blocks = []
        for line in f:
            for url in line.split():
                blocks.append(url)
        return blocks

def getDirects():
    with open('direct') as f:
        directs = []
        for line in f:
            for url in line.split():
                directs.append(url)
        return directs

def main():
    blocks = getBlocks()
    directs = getDirects()
    addBlock(*blocks)
    addDirect(*directs)

if __name__ == "__main__":
    main()
