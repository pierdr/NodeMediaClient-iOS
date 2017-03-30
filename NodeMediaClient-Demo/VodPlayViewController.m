//
//  VodPlayViewController.m
//  NodeMediaClient-Demo
//
//  Created by Mingliang Chen on 17/2/6.
//  Copyright © 2017年 Mingliang Chen. All rights reserved.
//
//  点播播放实例

#import "VodPlayViewController.h"
#import "TYVideoControlView.h"
#import <NodeMediaClient/NodeMediaClient.h>
#import "DefConfig.h"

@interface VodPlayViewController () <TYVideoControlViewDelegate,NodePlayerDelegate>
@property (nonatomic, strong) NodePlayer *np;
@property (nonatomic, strong) TYVideoControlView *controlView;
@end

@implementation VodPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _np = [[NodePlayer alloc] init];
    _np.view.frame = self.view.bounds;
    _np.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_np.view];
    
    
    _controlView = [[TYVideoControlView alloc] init];
    _controlView.frame = self.view.bounds;
    [_controlView setDelegate:self];
    [_controlView setTitle:@"这是视频标题"];
    _controlView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    [_controlView addGestureRecognizer:hideTap];
    
    [self.view addSubview:_controlView];
    
    [_np setInputUrl:[[DefConfig sharedInstance] getVodPlayUrl]]; //输入地址,可以是HTTP的点播地址,也可以是本地文件路径
    [_np setBufferTime:[[DefConfig sharedInstance] getVodBufferTime]]; //设置启动缓冲时长 建议1000毫秒
    [_np setMaxBufferTime:[[DefConfig sharedInstance] getVodMaxBufferTime]]; //设置最大缓冲时长,当填满时,网络流点播就不再下载.避免过多的数据被提前下载缓冲.建议20*1000毫秒
    [_np setNodePlayerDelegate:self];
    [_np setContentMode:UIViewContentModeScaleAspectFit];
    [_np start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)singleTapAction:(UITapGestureRecognizer *)tap
{
    if ([_controlView contentViewHidden]) {
        [self showControlViewWithAnimation:YES];
    }else {
        [self hideControlViewWithAnimation:YES];
    }
}

- (void)showControlViewWithAnimation:(BOOL)animation
{
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [_controlView setContentViewHidden:NO];
        }];
    }else {
        [_controlView setContentViewHidden:NO];
    }
    [_controlView setPlayBtnState:![_np isPlaying]];
}

- (void)hideControlViewWithAnimation:(BOOL)animation
{
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [_controlView setContentViewHidden:YES];
        }];
    }else {
        [_controlView setContentViewHidden:YES];
    }
}

- (NSString *)covertToStringWithTime:(NSInteger)time
{
    NSInteger seconds = time % 60;
    NSInteger minutes = (time)%3600/60;
    NSInteger hours = (time)%(24*3600)/3600;
    if(hours > 0) {
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours,(long)minutes,(long)seconds];
    } else {
        return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes,(long)seconds];
    }
    
}

- (BOOL)isOrientationPortrait
{
    return [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown;
}

- (void)changeToOrientation:(UIInterfaceOrientation)orientation
{
    NSNumber *value = [NSNumber numberWithInt:orientation];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
}

- (void) onEventCallback:(id)sender event:(int)event msg:(NSString *)msg {
    NSLog(@"onEventCallback:[%d] %@",event,msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (event) {
            case 1000:
                [_controlView setLoadingViewHidden:NO];
                break;
            case 1001:
                break;
            case 1003:
                break;
            case 1004:
                break;
            case 1100:
            case 1101:
                [_controlView setLoadingViewHidden:NO];
                break;
            case 1102:
                [_controlView setLoadingViewHidden:YES];
                break;
            default:
                break;
        }
    });
    
}

- (void)videoControlView:(TYVideoControlView *)videoControlView recieveControlEvent:(TYVideoControlEvent)event {
    switch (event) {
        case TYVideoControlEventBack:
            if(![self isOrientationPortrait]) {
                [self changeToOrientation:UIInterfaceOrientationPortrait];
            } else {
                if (self.navigationController) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                [_np stop];
            }
            break;
        case TYVideoControlEventFullScreen:
            [self changeToOrientation:UIInterfaceOrientationLandscapeRight];
            break;
        case TYVideoControlEventNormalScreen:
            [self changeToOrientation:UIInterfaceOrientationPortrait];
            break;
        case TYVideoControlEventPlay:
            [_np start];
            break;
        case TYVideoControlEventSuspend:
            [_np pause];
            break;
        case TYVideoControlEventRefresh:
        {
            long duration = [_np getDuration];
            long cp = [_np getCurrentPosition];
            long bp = [_np getBufferPosition];
            //            NSLog(@"duration:%ld cp:%ld bp:%ld",duration,cp,bp);
            NSString *totalTime = [self covertToStringWithTime:duration/1000];
            NSString *currentTime = [self covertToStringWithTime:cp/1000];
            [_controlView setPlayBtnState:![_np isPlaying]];
            [_controlView setTotalVideoTime:totalTime];
            [_controlView setCurrentVideoTime:currentTime];
            [_controlView setSliderProgress:((float)cp / duration)];
            [_controlView setBufferProgress:((float)bp / duration)];
        }
            break;
        default:
            break;
    }
    
}

- (void)videoControlView:(TYVideoControlView *)videoControlView state:(TYSliderState) state sliderToProgress:(CGFloat)progress {
    switch (state) {
        case TYSliderStateBegin:
            
            break;
        case TYSliderStateDraging:
            break;
        case TYSliderStateEnd:
        {
            long duration = [_np getDuration];
            long pos = duration*progress;
            [_np seekTo:pos];
        }
            break;
    }
}

@end
