# PiChat

[![Build Status](https://travis-ci.org/Big-Pi/PiChat.svg?branch=master)](https://travis-ci.org/Big-Pi/PiChat)

**A Realtime Chat App with LeanCloud as Back-end**

**一个即时聊天 App 基于 LeanCloud.**

由于包含第三方库的 Pod,App 源码较大

---
可以注册账号,也可以使用 App 的2个测试账号

- 账号1 : `1@qq.com` 
- 账号2 :`2@qq.com`
- 密码 : `666`

后台数据请登录 [Leancloud](https://leancloud.cn) 控制台查看

- 账号 `wangdapishuai@163.com`
- 密码 `8PcU2)vnXbY^to`

---

![](./Img/启动界面.png)
![](./Img/消息列表.png)
![](./Img/联系人.png)
![](./Img/朋友圈.png)
![](./Img/关于.png)

---
- 朋友圈计算 UICollectionview Cell Size,还有小 Bug
- 准备加入 [yapstudios/YapDatabase](https://github.com/yapstudios/YapDatabase) 来缓存网络数据

---
## 使用的第三方库:



**Leancloud**

- pod 'AVOSCloud'
- pod 'AVOSCloudIM'     // IM
- pod 'LeanCloudSocial'  // SNS 登录
- pod 'LeanCloudFeedback' // 问题反馈

**twitter 的 Fabric 的 Crashlytics**

- pod 'Fabric'
- pod 'Crashlytics' //崩溃日志

**其它**

- pod 'JSQMessagesViewController' //聊天消息界面
- pod 'MBProgressHUD'
- pod 'Masonry'
- pod 'GJAlertController'
- pod 'IQKeyboardManager'
- pod 'DateTools'
- pod 'MWPhotoBrowser'       //视频,图片浏览器
- pod 'MJRefresh'
- pod 'SCSiriWaveformView'
- pod 'QBImagePickerController'  //图片选择
- pod 'DGActivityIndicatorView'
- pod 'JSBadgeView'   //小红点
- pod 'RealReachability'
#
- pod 'YapDatabase'   //本地缓存
- pod 'Reveal-iOS-SDK', :configurations => ['Debug']