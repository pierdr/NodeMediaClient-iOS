//
//  PlayViewController.m
//  NodeMediaClient-Demo
//
//  Created by Mingliang Chen on 15/8/25.
//  Copyright (c) 2015年 NodeMedia. All rights reserved.
//

#import "PlayViewController.h"
#import "LivePlayer.h"
#import "DefConfig.h"

@interface PlayViewController()<LivePlayerDelegate>

@property (weak, nonatomic) IBOutlet UIView *playVideoView;
@property (nonatomic) LivePlayer *lp;

@end

@implementation PlayViewController

-(void)viewDidLoad {
    [super viewDidLoad];
    
    //状态栏透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    //屏幕常亮
    [ [ UIApplication sharedApplication] setIdleTimerDisabled:YES ];
    
    
    _lp = [[LivePlayer alloc] init]; //1.alloc and init
    [_lp setLivePlayerDelegate:self];//2.设置事件Delegate
    
    /**
     * 3.设置播放UIView
     *   画面填充模式,当前支持
     *   拉伸填充 UIViewContentModeScaleToFill      //做全屏发布播放类应用,建议用拉伸填充模式适应iphone4和iPad的非16:9的屏幕分辨率
     *   等比缩放 UIViewContentModeScaleAspectFit
     */
    [_lp setUIView:_playVideoView ContentMode:UIViewContentModeScaleAspectFit];
    
    
    //4.设置本地缓存时长 单位毫秒
    [_lp setBufferTime:1000];
    
    //5.开始播放 异步操作,调用后即返回,播放状态由LivePlayerDelegate回调.
    //v0.4版本后支持软件解码H.264+AAC的HLS协议
    [_lp startPlay:[[DefConfig sharedInstance] getPlayUrl]];
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    dispatch_async(dispatch_get_main_queue(), ^{
        if(_lp) {
            [_lp stopPlay]; //停止播放,同步操作,所有线程退出后返回,有一定等待时间
            _lp = nil;      //释放LivePlayer对象
        }
    });

}

-(void) onEventCallback:(int)event msg:(NSString *)msg {
    NSLog(@"onEventCallback:%d %@",event,msg);
    switch (event) {
        case 1000:
            //开始连接播放流
            break;
        case 1001:
            //播放流连接成功 开始播放
            break;
        case 1002:
            //播放流连接失败
            break;
        case 1003:
            //播放流连接失败或播放过程中网络异常断开,进入自动重连
            break;
        case 1004:
            //播放停止 所有资源处于可释放状态.
            break;
        case 1005:
            //播放中遇到网络异常
            break;
        case 1100:
            //NetStream.Buffer.Empty        数据缓冲为空 播放停止
            break;
        case 1101:
            //NetStream.Buffer.Buffering    开始缓冲数据
            break;
        case 1102:
            //NetStream.Buffer.Full         数据缓冲足够 开始播放
            break;
        case 1103:
            //收到 Stream EOF 或者 NetStream.Play.UnpublishNotify
            //iOS v0.4以后 发布端停止发布,会回调此事件,播放端进入自动重连流程.如不需要自动重连,可在此处停止播放
//            [_lp stopPlay];
            break;
        default:
            break;
    }

}

@end
