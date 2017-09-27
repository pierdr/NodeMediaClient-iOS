//
//  LiveMultiPlayViewController.m
//  NodeMediaClient-Demo
//
//  Created by Mingliang Chen on 17/2/6.
//  Copyright © 2017年 Mingliang Chen. All rights reserved.
//

#import "LiveMultiPlayViewController.h"
#import <NodeMediaClient/NodeMediaClient.h>

@interface LiveMultiPlayViewController () <NodePlayerDelegate>
@property (nonatomic, strong) NodePlayer *np1;
@property (nonatomic, strong) NodePlayer *np2;
@property (nonatomic, strong) NodePlayer *np3;
@end

@implementation LiveMultiPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _np1 = [[NodePlayer alloc] init];
    UIView *view1 = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view1];
    [_np1 setPlayerView:view1];
    [_np1 setInputUrl:@"rtmp://xyplay.nodemedia.cn/live/stream_1001"];
    [_np1 setNodePlayerDelegate:self];
    [_np1 setContentMode:UIViewContentModeScaleAspectFit];
    [_np1 start];
    
    _np2 = [[NodePlayer alloc] init];
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(20, 300, 90, 160)];
    [self.view addSubview:view2];
    [_np2 setPlayerView:view2];
    [_np2 setInputUrl:@"rtmp://xyplay.nodemedia.cn/live/stream_1002"];
    [_np2 setNodePlayerDelegate:self];
    [_np2 setContentMode:UIViewContentModeScaleAspectFit];
    [_np2 start];
    
    _np3 = [[NodePlayer alloc] init];
    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(200, 300, 90, 160)];
    [self.view addSubview:view3];
    [_np3 setPlayerView:view3];
    [_np3 setInputUrl:@"rtmp://xyplay.nodemedia.cn/live/stream_1003"];
    [_np3 setNodePlayerDelegate:self];
    [_np3 setContentMode:UIViewContentModeScaleAspectFit];
    [_np3 start];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    closeBtn.frame = CGRectMake(16, 28, 40, 30);
    [closeBtn addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [_np1 stop];
    [_np2 stop];
    [_np3 stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) onEventCallback:(id)sender event:(int)event msg:(NSString *)msg {
    NSString *who = [sender isEqual:_np1] ? @"np1" : [sender isEqual:_np2] ? @"np2" : @"np3";
    NSLog(@"%@ [%@] onEventCallback:[%d] msg:%@",sender,who,event,msg);
}

- (void)onClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
