//
//  LivePlayViewController.m
//  NodeMediaClient-Demo
//
//  Created by Mingliang Chen on 17/2/6.
//  Copyright © 2017年 Mingliang Chen. All rights reserved.
//
//  直播播放实例

#import "LivePlayViewController.h"
#import <NodeMediaClient/NodeMediaClient.h>
#import "DefConfig.h"

@interface LivePlayViewController () <NodePlayerDelegate>
@property (nonatomic, strong) NodePlayer *np;
@end

@implementation LivePlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _np = [[NodePlayer alloc ] init];
    // _np.view为视频显示view,直接当作子视图插入即可
    _np.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _np.view.frame = self.view.bounds;
    [self.view addSubview:_np.view];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(16, 28, 40, 30);
    [closeBtn addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    [_np setNodePlayerDelegate:self];//设置事件代理
    [_np setInputUrl:[[DefConfig sharedInstance] getPlayUrl]]; //设置输入流地址,可以是RTMP/RTSP/HTTP-FLV/HLS等协议
    [_np setBufferTime:[[DefConfig sharedInstance] getBufferTime]];//设置首屏启动缓冲时长,不是实际等待时间,而是缓冲区存放的时长,建议100-500毫秒
    [_np setMaxBufferTime:[[DefConfig sharedInstance] getMaxBufferTime]];//设置缓冲区最大时长,该值与最大延迟有直接关系.因网络抖动\来电等因素引起的累计延迟,会根据该值的大小自动抛弃过期数据.建议1000-2000毫秒
    [_np setContentMode:UIViewContentModeScaleAspectFit];//设置画面填充模式.
    [_np setHwEnable:YES];//设置开启硬解码,默认已开启,可以不调用.系统版本不支持或硬解码器初始化失败,自动转为软解.
    [_np setConnArgs:@"S:info O:1 NS:uid:10012 NB:vip:1 NN:num:209.12 O:0"]; //类似ActionScript NetConnection.connect()时发送参数,rtmpdump风格
    [_np start];//开始播放
}

- (void)viewWillDisappear:(BOOL)animated {
    [_np stop];//2.0版后该方法立即返回,不阻塞线程,也不需要再设置对象为 nil
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onEventCallback:(id)sender event:(int)event msg:(NSString *)msg {
    NSLog(@"onEventCallback:[%d] msg:%@",event,msg);
    switch (event) {
        case 1000:
            //开始连接播放流
            break;
        case 1001:
            //播放流连接成功
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
        case 1006:
            //连接超时或数据缓存为空超时
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
            break;
        case 1104:
            //获取到视频分辨率 width x height
            break;
        default:
            break;
    }
}


@end
