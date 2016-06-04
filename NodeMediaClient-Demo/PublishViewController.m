//
//  ViewController.m
//  NodeMediaClient-Demo
//
//  Created by Mingliang Chen on 15/8/21.
//  Copyright (c) 2015年 NodeMedia. All rights reserved.
//

#import "PublishViewController.h"
#import "LivePublisher.h"
#include "KSHCaptureButton.h"
#import "DefConfig.h"


@interface PublishViewController () <LivePublisherDelegate>
@property (weak, nonatomic) IBOutlet UIView *cameraPreview;

@property (weak, nonatomic) IBOutlet KSHCaptureButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@property (weak, nonatomic) IBOutlet UIButton *flashBtn;
@property (weak, nonatomic) IBOutlet UIView *tabBar;

@property (nonatomic) LivePublisher *lp;
@property (nonatomic) bool isStarting;
@property (nonatomic) bool isFlashEnable;
@end

@implementation PublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //隐藏导航条
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    
    //屏幕常亮
    [ [ UIApplication sharedApplication] setIdleTimerDisabled:YES ];
    
    _lp = [[LivePublisher alloc] init]; // 1.
    [_lp setLivePublisherDelegate:self]; // 2.设置事件delegate
    
    /**
     * 设置输出音频参数
     * bitrate 码率 32kbps
     * aacProfile 音频编码复杂度 部分服务端不支持HE-AAC,会导致发布失败，如果服务端支持，直接用HE-AAC
     *  AAC_PROFILE_LC		低复杂度编码
     * 	AAC_PROFILE_HE		高效能编码 ，能达到LC-AAC一半的码率传输相同的音质
     */
    [_lp setAudioParamBitrate:32*1000 aacProfile:AAC_PROFILE_HE];
    
    /**
     * 设置输出视频参数
     * width 视频宽
     * height 视频高   注意，视频最终输出的高宽和发布方向有关，这里设置 16：9的分辨率就行，sdk自动切换。
     * fps    视频帧率
     * bitrate 视频码率	注意，sdk 1.0.7以后，视频码率为最大码率，可以比以前的版本值高一点，编码器自动调节
     * avcProfile  视频编码复杂度，高中低为三者比较相对而言。可根据应用场景选择
     * 	AVC_PROFILE_BASELINE		低CPU，低画质
     *  AVC_PROFILE_MAIN			中CPU，中画质
     *  AVC_PROFILE_HIGH			高CPU，高画质
     *
     * 以下建议分辨率及比特率 不用超过1280x720
     * 320X180@15  ~~ 300kbps  ~~ baseline
     * 568x320@15  ~~ 400kbps  ~~ baseline
     * 640X360@15  ~~ 500kbps  ~~ main
     * 854x480@15  ~~ 600kbps  ~~ main
     * 960x540@15  ~~ 800kbps  ~~ high
     * 1280x720@15 ~~ 1000kbps ~~ high
     */
    [_lp setVideoParamWidth:640 height:360 fps:15 bitrate:500*1000 avcProfile:AVC_PROFILE_MAIN];
    
    //5. 开启背景噪音消除，软件消除算法，有一定CPU消耗
    [_lp setDenoiseEnable:YES];
    
    //6. 设置美颜等级  0 关闭 ,1-5 5个等级 越大越亮,磨皮程度越高,随时可以设置
    [_lp setSmoothSkinLevel:0];
    
    //7. 设置硬编码开启,需要iOS版本8.0 , 如果低于8.0的系统,仍然使用软编码;
    [_lp setHWEnable:YES];
    
    /*
     * 8. 开始预览摄像头画面，
     * _cameraPreviewView   传入UIView视图对象，当传入nil时，则发布纯音频流
     * camId：CAMERA_FRONT：初始使用前置摄像头, CAMERA_BACK:后置
     * frontMirror：当为NO时，前置摄像头预览不再是镜像模式，而是和别人看到的画面一致
     */
    [_lp startPreview:_cameraPreview camId:CAMERA_FRONT frontMirror:YES];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    dispatch_async(dispatch_queue_create("close_dispatch",0), ^{
        //停止预览，停止发布
        [_lp stopPreview];
        [_lp stopPublish];
        _lp = nil;
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //还没有开始发布视频的时候，可以跟随界面旋转的方向设置视频与当前界面方向一致，但一经开始发布视频，是不能修改视频发布方向的了
    //请注意：如果视频发布过程中旋转了界面，停止发布，再开始发布，是不会触发"willRotateToInterfaceOrientation"进入这个参数设置的
    if(!_isStarting) {
        switch (toInterfaceOrientation) {
            case UIInterfaceOrientationPortrait:
                [_lp setVideoOrientation:VIDEO_ORI_PORTRAIT];
                break;
            case UIInterfaceOrientationPortraitUpsideDown:
                [_lp setVideoOrientation:VIDEO_ORI_PORTRAIT_REVERSE];
                break;
            case UIInterfaceOrientationLandscapeLeft:
                [_lp setVideoOrientation:VIDEO_ORI_LANDSCAPE_REVERSE];
                break;
            case UIInterfaceOrientationLandscapeRight:
                [_lp setVideoOrientation:VIDEO_ORI_LANDSCAPE];
                break;
                
            default:
                break;
        }
    }
    
}

-(void) onEventCallback:(int)event msg:(NSString *)msg {
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
            case 2102:
                //截图保存成功
                break;
            case 2103:
                //截图保存失败
                break;
            default:
                break;
        }
    });
}

- (IBAction)switchAction:(id)sender {
    [UIView transitionWithView:sender duration:0.3f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        [_lp switchCamera];
        
        //切换摄像头操作的同时关闭闪关灯,因为打开前置摄像头无法开闪光灯
        [_lp setFlashEnable:NO];
        [_flashBtn setImage:[UIImage imageNamed:@"SwitchFlash_off"] forState:UIControlStateNormal];
    } completion:nil];
    
}

- (IBAction)startAction:(id)sender {
    if(_isStarting) {
        [_lp stopPublish];
    } else {
        //设置发布视频方向
        //如果不调用，则视频方向为调用预览方法时的界面方向，如果需要指定固定的发布方向，则在开始发布之前调用此方法 (可选方法)
        //        [_lp setVideoOrientation:VIDEO_ORI_PORTRAIT];
        
        //也可用在明确需要横屏16:9 的视频发布 但用户锁定了手机方向旋转，设置参数为：VIDEO_ORI_LANDSCAPE 或 VIDEO_ORI_LANDSCAPE_REVERSE 并提示用户横屏握手机
        //        [_lp setVideoOrientation:VIDEO_ORI_LANDSCAPE];
        
        //        _lp.pageUrl = @"http://www.pageurl.com";
        //        _lp.swfUrl = @"http://www.swfurl.com";
        
        //        _lp.publishType = PUBLISH_TYPE_RECORD;    //设置为发布录制模式 fms与red5兼容
        
        //开始发布 普通模式
        [_lp startPublish:[[DefConfig sharedInstance] getPublishUrl]];
        
    }
}

- (IBAction)flashAction:(id)sender {
    int ret = 0;
    if(_isFlashEnable) {
        ret =[_lp setFlashEnable:NO];
    }else {
        ret =[_lp setFlashEnable:YES];
    }
    
    if(ret == 1 ) {
        //闪光灯开启
        [sender setImage:[UIImage imageNamed:@"SwitchFlash_on"] forState:UIControlStateNormal];
        _isFlashEnable = YES;
    }else if(ret == 0) {
        //闪光灯关闭
        [sender setImage:[UIImage imageNamed:@"SwitchFlash_off"] forState:UIControlStateNormal];
        _isFlashEnable = NO;
    }else {
        //不支持开关闪光灯
    }
    
}


- (IBAction)capAction:(id)sender {
    //截取当前摄像头预览图 存储到应用程序沙箱目录 在startPreview后即可调用,stopPreview后无法使用
    static int count = 0;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *fileName = [NSString stringWithFormat:@"publish_cap_%d.jpg", count++];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    [_lp capturePicture:filePath]; //1.x版 截图为异步操作,结果以eventCallback形式通知: 2102成功 2103失败,可以保存美颜后的效果
}


- (IBAction)beautyLevelChange:(id)sender {
    UISlider* slider = (UISlider*)sender;
    
    /*
     * 设置美颜等级 0-5 ,可随时调节
     * 0就是关闭美颜
     * 1-5 美颜等级 越高越亮磨皮程度越高
     */
    [_lp setSmoothSkinLevel:slider.value];
    
}

@end