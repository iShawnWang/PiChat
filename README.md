# PiChat

A Realtime Chat App with LeanCloud as Back-end

LeanCloud 有完整的数据存储,实时通信,消息推送(未测试)功能…



# Depracted

### 原因:

只能实现发送 text 和同步(阻塞)发送图片视频,

~异步发送20mb 视频,并且实时展示进度,保证消息顺序不乱...无法实现, 

在上传文件时,用 notification 实时更新进度可以实现, 

但是上传20mb 视频的时间内...消息并没有发出去....所以此时自己或者其他人发送的消息会实时更新,,,然后我们的20mb 视频的发送顺序就被放在后面了...无法保证消息顺序不乱!!!



# 看了2个开源聊天

[ChatSecure-iOS](https://github.com/ChatSecure/ChatSecure-iOS)

[EncryptedChat](https://github.com/relatedcode/EncryptedChat)

也没有实现如上功能…  : (  