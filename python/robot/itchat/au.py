#!/usr/bin/env python
# -*- coding: utf-8 -*-
# --------------------------------------------------
#Author:    LJ
#Email: admin@attacker.club

#Mail:  admin@attacker.club
#Date:  2018/1/18
#Description:   
# --------------------------------------------------

import itchat
import requests

def getResponse(_info):
    apiUrl = 'http://www.tuling123.com/openapi/api'
    data = {
        'key'    : '86fc7031f14946dbbdca9a1f056aea99',
        # 如果7c1ccc2786df4e1685dda9f7a98c4ec9这个Tuling Key不能用，tuling123官网注册一个
        'info'   : _info, # 这是我们发出去的消息
        'userid' : 'wechat-robot', # 这里你想改什么都可以
    }
    r = requests.post(apiUrl, data=data).json()
    return r


#itchat 装饰器
@itchat.msg_register(itchat.content.TEXT)
def text_reply(msg):
    #return "Robot发言人：" + getResponse(msg["Text"])["text"]
    return getResponse(msg["Text"])["text"]
    #返回tuling123拿到的元素

#itchat.auto_login(enableCmdQR=True)
    #服务器字符二维码

itchat.auto_login()
itchat.run()