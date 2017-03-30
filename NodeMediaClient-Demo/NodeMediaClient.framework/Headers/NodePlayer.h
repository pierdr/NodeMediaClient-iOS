//
//  NodePlayer.h
//  NodeMediaClient v2.0.2
//
//  Created by Mingliang Chen on 16/12/29.
//  Copyright © 2016年 Mingliang Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol NodePlayerDelegate

-(void) onEventCallback:(id)sender event:(int)event msg:(NSString*)msg;

@end

@interface NodePlayer : NSObject

@property (nonatomic, weak) id<NodePlayerDelegate> nodePlayerDelegate;

#pragma mark 参数
///音视频流地址,也可以是本地文件绝对路径
@property (nonatomic, strong) NSString *inputUrl;

///rtmp协议连接下附加pageurl参数
@property (nonatomic, strong) NSString *pageUrl;

///rtmp协议连接下附加swfUrl参数
@property (nonatomic, strong) NSString *swfUrl;

///启动缓冲区时长,单位毫秒.默认值 500
@property (nonatomic) int bufferTime;

/**
 * @brief 最大缓冲区时长,单位毫秒.默认值 1000
 *
 * 当输入地址为直播流时,该值决定了当前缓冲区内与直播时间线的最大延迟,当超过后,丢弃过期数据,完成追帧
 *
 * 当输入地址为本地文件或点播流时,该值决定了最大读取缓冲
 */
@property (nonatomic) int maxBufferTime;


///自动重连超时等待时间,单位毫秒,默认2000. 当为0时不自动重连
@property (nonatomic) int autoReconnectWaitTimeout;


///连接或数据为空超时等待时间,单位毫秒,默认0. 当为0时一直等待
@property (nonatomic) int connectWaitTimeout;

/**
 * @brief 视频缩放模式
 *
 * 当前支持三种缩放模式: 填充缩放,等比缩放,等比填充缩放
 *
 * (UIViewContentModeScaleToFill) [缩放填充]模式将整个视频填充到给定的显示区域,当显示区域与视频分辨率不一致时,发生画面被拉长或压扁,但没有黑边
 *
 * (UIViewContentModeScaleAspectFit) [等比缩放]模式将整个视频等比例缩放后显示到给定区域,当显示区域与视频分辨率不一致时,画面仍然保持正常比例,但有黑边
 *
 * (UIViewContentModeScaleAspectFill) [等比填充缩放]模式将整个视频等比例缩放后拉伸填充给定区域,当显示区域与视频分辨率不一致时,裁剪掉多余的视频画面,画面仍然保持正常比例,没有黑边,但视频会显示不完全
 */
@property (nonatomic) int contentMode;

/**
 * @brief 是否开始硬件解码加速,开始播放前设置有效,默认开启.
 *
 * 当视频编码为H.264\MPEG4\H.263,音频编码为AAC\AC3\MP3时,可以使用硬件解码加速来降低cpu占用,降低能耗.\
 * 
 * 当初始化失败,或者系统版本不支持时,自动转为软解码.
 */
@property (nonatomic) BOOL hwEnable;

//是否开启音频 随时可以设置
@property (nonatomic) BOOL audioEnable;

//是否开启视频 随时可以设置
@property (nonatomic) BOOL videoEnable;

///是否接收音频数据 只能在开始播放前设置,注意:不是所有流媒体服务器支持该指令
@property (nonatomic) BOOL receiveAudio;

///是否接收视频数据 只能在开始播放前设置,注意:不是所有流媒体服务器支持该指令
@property (nonatomic) BOOL receiveVideo;

///是否以subscribe模式播放视频
@property (nonatomic) BOOL subscribe;


#pragma mark 属性
///视频显示view,作为子视图插入
@property (nonatomic, readonly, weak) UIView *view;

///获取当前视频总时长,单位毫秒.直播流为0
-(long) getDuration;

///获取当前播放位置,单位毫秒,
-(long) getCurrentPosition;

///获取缓冲位置,单位毫秒
-(long) getBufferPosition;

///获取当前是否为播放状态
-(BOOL) isPlaying;

///获取当前播放地址是否为直播流
-(BOOL) isLive;

#pragma mark 方法
///开始播放
-(int) start;

///停止播放
-(int) stop;

///暂停播放,当前为直播流时无效
-(int) pause;

///快进或快退到给定位置.可以在开始播放前设置.
-(int) seekTo:(long) pos;

@end
