# NodeMediaClient
一个简单，快速，免费的直播SDK.

# Cocoapods 安装
## 创建 Podfile 文件
```ruby
source 'https://github.com/CocoaPods/Specs.git'
target 'QLive' do
pod 'NodeMediaClient'
end
```
## 安装
```shell
pod install
```

# 简单用法

## NodePlayer
```
#import <NodeMediaClient/NodeMediaClient.h>
......

@property (strong,nonatomic) NodePlayer *np;

......
// 开始播放直播视频
    _np = [[NodePlayer alloc] init];
    [_np setPlayerView:self.view];
    [_np setInputUrl:@"rtmp://192.168.0.10/live/stream"];
    [_np start];
    
......

// 停止播放
    [_np stop];
```

## NodePublisher

**请确认描述条目'Privacy - Microphone Usage Description' 和 'Privacy - Camera Usage Description' 已经添加入info.plist**

```
#import <NodeMediaClient/NodeMediaClient.h>

......

@property (strong, nonatomic) NodePublisher *np;

......
// 开始摄像头预览和视频推流
    _np = [[NodePublisher alloc] init];
    [_np setCameraPreview:self.view cameraId:CAMERA_FRONT frontMirror:YES];
    [_np setAudioParamBitrate:32000 profile:AUDIO_PROFILE_HEAAC];
    [_np setVideoParamPreset:VIDEO_PPRESET_16X9_360 fps:15 bitrate:500000 profile:VIDEO_PROFILE_MAIN frontMirror:NO];
    [_np setOutputUrl:@"rtmp://192.168.0.10/live/stream"];
    [_np startPreview];
    [_np start];

......


// 停止摄像头预览和推流
    [_np stopPreview];
    [_np stop];
```
# 特性
## NodePlayer

## NodePublisher

## NodeStreamer

# 高级版
- 硬件加速的视频编码、解码器
- 麦克风降噪
- 平滑肌肤美颜

请联系商务服务邮箱 : service@nodemedia.cn
