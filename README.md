# NodeMediaClient
一个简单，快速，免费的直播SDK.
A simple, fast, and free live SDK.

# Cocoapods 安装
## 创建 Podfile 文件
## Create Podfile
```ruby
# Uncomment the next line to define a global platform for your project
platform :ios, '8.0'

target 'QLive' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_modular_headers!

  # Pods for QLive
  pod 'NodeMediaClient', '~> 2.8.7' 
end

```
## 安装
## Installation
```shell
pod install
```

# 简单用法
# Simple usage
完整用例[QLive源码](https://github.com/NodeMedia/QLive-iOS) [(API文档)](https://github.com/NodeMedia/NodeMediaClient-iOS/tree/2.x/docs)
Complete use case [QLive source code][(API document)](https://github.com/NodeMedia/NodeMediaClient-iOS/tree/2.x/docs)

## NodePlayer
```
#import <NodeMediaClient/NodeMediaClient.h>
......

@property (strong,nonatomic) NodePlayer *np;

......
// 开始播放直播视频
// Start playing live video
    _np = [[NodePlayer alloc] init];
    [_np setPlayerView:self.view];
    [_np setInputUrl:@"rtmp://192.168.0.10/live/stream"];
    [_np start];
    
......

// 停止播放
// Stop play
    [_np stop];
```

## NodePublisher

**请确认描述条目'Privacy - Microphone Usage Description' 和 'Privacy - Camera Usage Description' 已经添加入info.plist**
**Please confirm that the description items'Privacy-Microphone Usage Description' and'Privacy-Camera Usage Description' have been added to info.plist**
```
#import <NodeMediaClient/NodeMediaClient.h>

......

@property (strong, nonatomic) NodePublisher *np;

......
// 开始摄像头预览和视频推流
// Start camera preview and video streaming
    _np = [[NodePublisher alloc] init];
    [_np setCameraPreview:self.view cameraId:CAMERA_FRONT frontMirror:YES];
    [_np setAudioParamBitrate:32000 profile:AUDIO_PROFILE_HEAAC];
    [_np setVideoParamPreset:VIDEO_PPRESET_16X9_360 fps:15 bitrate:500000 profile:VIDEO_PROFILE_MAIN frontMirror:NO];
    [_np setOutputUrl:@"rtmp://192.168.0.10/live/stream"];
    [_np startPreview];
    [_np start];

......


// 停止摄像头预览和推流
// Stop camera preview and streaming
    [_np stopPreview];
    [_np stop];
```

# 特性
## NodePlayer
* 专为RTMP/RTSP等直播协议优化的码流解析器，极短的分析时间，秒开视频流
* NEON指令集优化的软件解码器，性能好，兼容性强
* 视频编码:H.265/H.264/H.263/MPEG4支持硬解码
* 支持的网络协议 RTMP/RTMPT/RTMPE/RTSP/HLS/HTTP(S)-FLV/KMP
* 支持的视频解码器:H.264, H.265,
* 支持的音频解码器:AAC, SPEEX, NELLYMOSER, G.711
* OpenGL ES视频渲染
* 全自动网络异常重连
* 支持播放中途来电保持网络流，暂停播放，挂机后继续播放
* 支持设置最大缓冲时长,杜绝延迟累计
* 支持多路直播流同时播放
* RTMP支持设置swfUrl和pageUrl
* RTMP支持设置Connect Arguments (rtmpdump风格)
* RTMP支持Adobe auth模式的鉴权验证 如rtmp://user:pass@server:port/app/name
* RTMP支持发送FCSubscribe命令，兼容国外Akamai, Edgecast , Limelight 等CDN
* RTSP支持的传输协议: TCP/UDP/UDP_MULTICAST/HTTP
* RTSP支持海康Smart265解码播放
* 支持RTMP/HTTP-FLV视频解密播放
# Features

## NodePlayer
* Streaming parser optimized for RTMP/RTSP and other live broadcast protocols, extremely short analysis time, and video streaming in seconds
* Software decoder optimized by NEON instruction set, with good performance and strong compatibility
* Video encoding: H.265/H.264/H.263/MPEG4 supports hard decoding
* Supported network protocol RTMP/RTMPT/RTMPE/RTSP/HLS/HTTP(S)-FLV/KMP
* Supported video decoders: H.264, H.265,
* Supported audio codecs: AAC, SPEEX, NELLYMOSER, G.711
* OpenGL ES video rendering
* Automatic network abnormal reconnection
* Support to keep the network stream of incoming calls during playback, pause playback, and resume playback after hanging up
* Support setting the maximum buffer time to prevent delay accumulation
* Support simultaneous playback of multiple live streams
* RTMP supports setting swfUrl and pageUrl
* RTMP supports setting Connect Arguments (rtmpdump style)
* RTMP supports authentication verification in Adobe auth mode, such as rtmp://user:pass@server:port/app/name
* RTMP supports sending FCSubscribe commands, compatible with foreign CDNs such as Akamai, Edgecast, Limelight, etc.
* Transport protocol supported by RTSP: TCP/UDP/UDP_MULTICAST/HTTP
* RTSP supports Hikvision Smart265 decoding and playback
* Support RTMP/HTTP-FLV video decryption playback

## NodePublisher
* H.264/AAC 组合的RTMP协议音视频流发布
* 全屏视频采集，1080p原画质缩放
* NEON指令集优化H.264软件编码器，性能强劲，兼容性极强
* H.264支持Baseline, Main, High profile
* iOS8以上支持视频硬编码
* 支持手机旋转,横屏16:9，竖屏9:16分辨率自动输出横竖屏视频流
* 支持4:3分辨率,1:1分辨率输出
* NEON优化AAC软件编码器，极少CPU占用，支持LC和HE profile，音质还原效果好
* 支持SPEEX音频编码
* 支持环境背景噪音抑制
* 支持发布中途切换前后摄像头
* 支持闪光灯开关
* 支持全时自动对焦与手动对焦切换
* 支持单音频流发布
* 支持发布中途来电保持网络流，暂停发布，挂机后继续发布
* 支持预览摄像头后,任意时刻截图
* 内置基于GPU加速的5级磨皮美白滤镜
* 支持动态设置视频码率
* 支持视频码率自适应网络带宽
* 支持GPU算法的镜头缩放,兼容性好
* 全自动网络异常重连
* 不依赖\不冲突GPUImage
* 支持RTMP视频加密推流

* H.264/AAC combined RTMP protocol audio and video streaming release
* Full screen video capture, 1080p original quality zoom
* NEON instruction set optimized H.264 software encoder, with strong performance and strong compatibility
* H.264 supports Baseline, Main, High profile
* iOS8 and above support video hard coding
* Support mobile phone rotation, horizontal screen 16:9, vertical screen 9:16 resolution automatically output horizontal and vertical screen video stream
* Support 4:3 resolution, 1:1 resolution output
* NEON optimizes the AAC software encoder with very little CPU usage, supports LC and HE profiles, and has a good sound quality restoration effect
* Support SPEEX audio encoding
* Support environmental background noise suppression
* Support switch between front and rear cameras during release
* Support flash switch
* Support full-time auto focus and manual focus switch
* Support single audio stream release
* Supports the release of midway calls to maintain the network flow, pause the release, and continue the release after hanging up
* After previewing the camera, take a screenshot at any time
* Built-in GPU-accelerated 5-level dermabrasion whitening filter
* Support dynamic setting of video bitrate
* Support video bit rate adaptive network bandwidth
* Supports lens scaling of GPU algorithm, good compatibility
* Automatic network abnormal reconnection
* Does not depend on \ Does not conflict GPUImage
* Support RTMP video encryption and push streaming

# 支持的流媒体服务端
# Supported streaming media server
fms, wowza, evostream, red5, crtmpserver, nginx-rtmp-module, srs, [Node-Media-Server](https://github.com/illuspas/Node-Media-Server) 及其他标准RTMP协议服务端

# 跨平台开源流媒体服务端
# Cross-platform open source streaming media server
[Node-Media-Server](https://github.com/illuspas/Node-Media-Server) 
基于Node.JS开发, 跨平台/高性能, 支持RTMP协议推流,RTMP/HTTP-FLV/WebSocket-FLV播放, 内置推流鉴权/播放防盗链/GOP缓存急速秒开.
Based on Node.JS development, cross-platform/high performance, support RTMP protocol push streaming, RTMP/HTTP-FLV/WebSocket-FLV playback, built-in push streaming authentication/play anti-theft link/GOP cache open in seconds.

# 直播视频加密解密
最新SDK实现了RTMP实时视频加密解密功能, 只对音视频内容进行加密, 不改变传输协议.  
不限流媒体服务端, 对现有架构无任何改动, 非常适合用作付费教育直播等场景.  
即使被抓包分析到流地址, 仍然无法被ffmpeg等任何工具解密.  
用户自定义密码, 可随时更换.
# Live video encryption and decryption
The latest SDK implements RTMP real-time video encryption and decryption functions, only encrypting audio and video content, without changing the transmission protocol.
Unlimited streaming media server, no changes to the existing architecture, very suitable for scenarios such as paid education live broadcast.
Even if the packet is captured and analyzed to the stream address, it still cannot be decrypted by any tools such as ffmpeg.
User-defined password can be changed at any time.

# 高级版特性
- 硬件加速的视频编码、解码器
- 麦克风降噪
- 平滑肌肤美颜
- RTMP音视频内容加密
# Advanced version features
-Hardware accelerated video encoder and decoder
-Microphone noise reduction
-Smooth skin beauty
-RTMP audio and video content encryption

请联系商务服务  
邮箱 : service@nodemedia.cn  
QQ : 281269007
