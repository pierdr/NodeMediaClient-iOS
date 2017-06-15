# NodeMediaClient-iOS

## 国内镜像
http://git.oschina.net/illuspas/NodeMediaClient-iOS

## 简介
NodeMediaClient是为移动端应用量身打造的基于RTMP协议的流媒体直播系统。通过集成本SDK，只需几个简单API调用，便可实现一套完整的直播流媒体应用基础。包含了流媒体应用中：『采集->编码->传输->解码->播放』的所有步骤。

## 编译环境
**xcode** 7以上

### iOS10适配说明
你需要在info.plist文件，添加“NSCameraUsageDescription，NSMicrophoneUsageDescription”两个Key，并在Value中添加使用描述。如 ：
```
  <key>NSCameraUsageDescription</key>
  <string>此 App 需要您的同意才能访问摄像头</string>
  <key>NSMicrophoneUsageDescription</key>
  <string>此 App 需要您的同意才能访问麦克风</string>
```
否则应用直接闪退崩溃

## 支持的系统平台
**iOS** 7.0及以上

## 支持的CPU架构
**iOS** armv7 armv7s arm64 i386 x86_64  

## 支持的流媒体服务端
fms, wowza, evostream, red5, crtmpserver, nginx-rtmp-module, srs, Node-Media-Server及其他标准RTMP协议服务端

## 支持的流媒体云服务器
[奥点云](http://www.aodianyun.com/)及其他标准RTMP协议云服务器

## 直播发布特性
* H.264/AAC 组合的RTMP协议音视频流发布
* 全屏视频采集，720p原画质缩放
* NEON指令集优化H.264软件编码器，性能强劲，兼容性极强
* H.264支持Baseline, Main, High profile
* iOS8以上支持视频硬编码
* 支持手机旋转,横屏16:9，竖屏9:16分辨率自动输出横竖屏视频流
* 支持4:3分辨率,1:1分辨率输出
* NEON优化AAC软件编码器，极少CPU占用，支持LC和HE profile，音质还原效果好
* 支持SPEEX音频编码
* 支持环境背景噪音抑制，不再有沙沙声
* 支持发布中途切换前后摄像头
* 支持闪光灯开关
* 支持全时自动对焦与手动对焦切换
* 支持单音频流发布
* 支持发布中途来电保持网络流，暂停发布，挂机后继续发布
* 支持预览摄像头后,任意时刻截图
* 支持定义为'live','record','append'的发布类型
* 支持Adobe auth模式的鉴权验证 如rtmp://user:pass@server:port/app/name
* 内置基于GPU加速的5级磨皮美白滤镜
* 支持动态设置视频码率
* 支持视频码率自适应网络带宽
* 支持GPU算法的镜头缩放,兼容性好
* 全自动网络异常重连

## 直播播放特性
* 只为RTMP协议优化的码流解析器，极短的分析时间，秒开RTMP视频流
* NEON指令集优化的软件解码器，性能好，兼容性强
* 视频编码:H.264/H.263/MPEG4,音频编码:AAC/AC3/MP3 支持硬解码
* 支持的网络协议 RTMP/RTMPT/RTSP/HLS/HTTP-FLV
* 支持的视频解码器:H.264, FLV, VP6, MPEG4
* 支持的音频解码器:AAC, MP3, SPEEX, NELLYMOSER, ADPCM_SWF, G.711
* OpenGL ES视频渲染
* 全自动网络异常重连
* 支持播放中途来电保持网络流，暂停播放，挂机后继续播放
* 支持播放中途任意时刻截图
* 支持设置最大缓冲时长,杜绝延迟累计
* 支持播放前设置receiveAudio,receiveVideo来控制只接收音频或视频流(需服务端实现，fms，red5支持)
* 支持发送FCSubscribe命令，兼容国外Akamai, Edgecast , Limelight 等CDN
* 支持主播停止推流后，播放端立即获取到结束状态（RTMP协议下）
* 支持多路直播流同时播放

## 直播串流器
v1.2.2新增NodeStreamer类,可用于户外环境下,具有RTSP协议的运动相机/无人机连接手机热点,通过手机4G网络串流到RTMP服务器.  
手机端不进行编解码,只有网络IO,不占用CPU.注:当按Home或锁屏时,系统会禁止后台网络传输,该功能目前在iOS上不实用,只为了与[Android端](https://github.com/NodeMedia/NodeMediaClient-Android)功能保持一致.  
v1.2.9增加对本地mp4文件直接进行串流的支持.(注意:并不进行二次编码,不改变码率\清晰度,不调整视频方向.手机内置相机录像的视频码率非常大,竖向录制的视频是旋转90度的)

## 双向音视频？
支持一个页面内同时发布视频和播放视频，但由于有回音问题，建议这种应用使用耳机，后期的版本会考虑回音消除

## ipv6
苹果2016年6月新政策规定新上架app必须支持ipv6-only。经过验证，我们已发布的版本均支持ipv6地址或解析到ipv6地址的域名进行直播。可使用<s>下面的地址验证，（注：需要测试环境具有公网ipv6环境）</s> 已失效,请自行搭建监听IPV6地址的Nginx-Rtmp测试
 * <s>rtmp://[lssv6.nodemedia.cn]/live/demo</s>
 * <s>rtmp://[2001:19f0:7000:80b5:5400:00ff:fe27:3f9b]/live/demo</s>

## 视频点播
### v2.0.0版本开始支持视频点播
 * 支持的协议格式 HTTP/FILE
 * 支持的封装格式 MP4/FLV/AVI/MPEGTS
 * 支持的视频格式 H.264/H.263/FLV/MPEG4/MJPEG
 * 支持的音频格式 AAC/AC3/MP3/NELLYMOSER/SPEEX/G.711
 * 播放/暂停/快进/时长等基本操作
 * 视频编码:H.264/H.263/MPEG4,音频编码:AAC/AC3/MP3 支持硬解码  
 
![img](https://raw.githubusercontent.com/NodeMedia/NodeMediaClient-iOS/v2.x/vodplay.jpg)

## 开发计划
 * 接入VR播放
 * H.265直播传输
 * 仿ActionScript3 NetConnect.call() 客户端服务端方法互调
 * 完善RTMFP协议支持(UDP,P2P,NETGROUP)

## H.265直播
目前v2.1.3支持非Adobe官方协议下H.265直播播放  
服务端需要修改codecId进行支持,NodeMedia将会在近期推出更新支持[nginx-rtmp-win32](https://github.com/illuspas/nginx-rtmp-win32)  
推流端需要修改ffmpeg进行支持,NodeMedia将会在近期推出更新支持[ffmpeg-hw-win32](https://github.com/illuspas/nginx-rtmp-win32)  
目前暂不支持手机端推流,x265软编码性能消耗较大,解决方案为手机端仍然以H.264推送到服务端,服务端进行H.264-->H.265实时转码,播放端解码H.265视频.  
经测试,在相同分辨率帧率清晰度的情况下,码率减小一半以上.  

## 商用授权
商业软件需购买授权,业务咨询\定制开发,请联系  
QQ:281269007  
Email:service@nodemedia.cn

## 免费授权(需审核)
学生,个人开源项目可免费申请授权版,请联系  
Email:service@nodemedia.cn
