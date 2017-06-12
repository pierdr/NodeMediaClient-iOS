//
//  LivePublishViewController.m
//  NodeMediaClient-Demo
//
//  Created by Mingliang Chen on 17/2/6.
//  Copyright © 2017年 Mingliang Chen. All rights reserved.
//

#import "LivePublishViewController.h"
#import <NodeMediaClient/NodeMediaClient.h>
#import "KSHCaptureButton.h"
#import "DefConfig.h"

@interface LivePublishViewController () <NodePublisherDelegate>
@property (weak, nonatomic) IBOutlet KSHCaptureButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *flashBtn;

@property (nonatomic,strong) NodePublisher *np;
@property (nonatomic) BOOL isStarting;
@property (nonatomic) BOOL isFlashEnable;
@end

@implementation LivePublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _np = [[NodePublisher alloc] init]; // 1.
    [_np setNodePublisherDelegate:self]; // 2.设置事件delegate
    [_np setAudioParamBitrate:32*1000 profile:AUDIO_PROFILE_HEAAC];
    [_np setCameraPreview:self.view cameraId:CAMERA_FRONT frontMirror:YES];
    [_np setVideoParamPreset:VIDEO_PPRESET_16X9_360 fps:24 bitrate:500*1000 profile:VIDEO_PROFILE_MAIN frontMirror:NO];
    [_np setDenoiseEnable:YES];
    [_np setBeautyLevel:3];
    [_np startPreview];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_np stopPreview];
    [_np stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) onEventCallback:(id)sender event:(int)event msg:(NSString *)msg {
    NSLog(@"onEventCallback:%d %@",event,msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (event) {
            case 2000:
                //发布流开始连接
                break;
            case 2001:
                //发布流连接成功 开始发布
                _startBtn.selected = YES;
                _isStarting = YES;
                break;
            case 2002:
                //发布流连接失败
                break;
            case 2003:
                //发布开始重连
                break;
            case 2004:
                //停止发布
                _startBtn.selected = NO;
                _isStarting = NO;
                break;
            case 2005:
                //发布中遇到网络异常
                break;
            case 2100:
                //发布端网络阻塞，已缓冲了2秒的数据在队列中
                break;
            case 2101:
                //发布端网络恢复畅通
                break;
            case 2104:
                //网络阻塞严重,无法继续推流,断开连接
                break;
            default:
                break;
        }
    });
}

- (IBAction)switchAction:(id)sender {
    [UIView transitionWithView:sender duration:0.3f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [_np switchCamera];
        
        //切换摄像头操作的同时关闭闪关灯,因为打开前置摄像头无法开闪光灯
        [_np setFlashEnable:NO];
        [_flashBtn setImage:[UIImage imageNamed:@"SwitchFlash_off"] forState:UIControlStateNormal];
    } completion:nil];
    
}

- (IBAction)startAction:(id)sender {
    if(_isStarting) {
        [_np stop];
    } else {
        [_np setConnArgs:@"S:info O:1 NS:uid:10012 NB:vip:1 NN:num:209.12 O:0"]; //类似ActionScript NetConnection.connect()时发送参数,rtmpdump风格
        [_np setOutputUrl:[[DefConfig sharedInstance] getPublishUrl]];
        [_np start];
    }
}

- (IBAction)flashAction:(id)sender {
    _np.flashEnable = !_isFlashEnable;
    
    if(_np.flashEnable) {
        //闪光灯开启
        [sender setImage:[UIImage imageNamed:@"SwitchFlash_on"] forState:UIControlStateNormal];
        _isFlashEnable = YES;
    }else {
        //闪光灯关闭
        [sender setImage:[UIImage imageNamed:@"SwitchFlash_off"] forState:UIControlStateNormal];
        _isFlashEnable = NO;
    }
    
}


- (IBAction)capAction:(id)sender {

    [_np capturePicture:^(UIImage *image) {
        if(image) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *fileName = [NSString stringWithFormat:@"publish_cap_%.0f.jpg", [[NSDate date] timeIntervalSince1970]];
            NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
            BOOL ret = [UIImageJPEGRepresentation(image, 0.8) writeToFile:filePath atomically:YES];
            NSLog(@"Capture camera picture save to %@ [%@]",filePath,ret?@"OK":@"NO");
            image = nil;
        }
    }];


}


- (IBAction)beautyLevelChange:(id)sender {
    UISlider* slider = (UISlider*)sender;
    
    /*
     * 设置美颜等级 0-5 ,可随时调节
     * 0就是关闭美颜
     * 1-5 美颜等级 越高越亮磨皮程度越高
     */
    [_np setBeautyLevel:slider.value];
    
}



- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
