//
//  LiveRestreamViewController.m
//  NodeMediaClient-Demo
//
//  Created by Mingliang Chen on 17/2/6.
//  Copyright © 2017年 Mingliang Chen. All rights reserved.
//

#import "LiveRestreamViewController.h"
#import <NodeMediaClient/NodeMediaClient.h>

@interface LiveRestreamViewController () <NodeStreamerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UITextField *outputTF;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UITextView *logView;
@property (nonatomic) NodeStreamer *ns;
@property (nonatomic) BOOL isStarting;

@end

@implementation LiveRestreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _logView.editable = NO;
    _logView.layoutManager.allowsNonContiguousLayout = NO;
    
    _ns = [[NodeStreamer alloc] init];
    [_ns  setNodeStreamerDelegate:self];
    [_ns setRtspTransport:RTSP_TRANSPORT_TCP];
    _isStarting = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startStreamingAct:(id)sender {
    if(_isStarting) {
        [_ns stopStreaming];
    }else {
        [_ns startStreamingWithInput:_inputTF.text output:_outputTF.text];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    [_ns stopStreaming];
}

-(void) onEventCallback:(id)sender event:(int)event msg:(NSString *)msg {
    NSLog(@"[NodeStreamer] event:%d msg:%@",event,msg);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * tex = _logView.text;
        tex = [ tex stringByAppendingFormat: @"Event: [%d] Msg:%@\r\n", event ,msg];
        _logView.text = tex;
        [_logView scrollRangeToVisible:NSMakeRange(_logView.text.length, 1)];
        switch (event) {
            case 3000:
                //串流器开始打开输入地址
                break;
            case 3001:
                //串流器输入地址打开成功
                //串流器开始打开输出地址
                break;
            case 3002:
                //串流器输出地址打开成功,开始串流
                _isStarting = true;
                [_startBtn setTitle:@"STOP" forState:UIControlStateNormal];
                break;
            case 3003:
                //串流器输入端打开失败
                break;
            case 3004:
                //串流器输出端打开失败
                break;
            case 3005:
                //串流中途输入端网络异常中断
                break;
            case 3006:
                //串流中途输出端网络异常中断
                break;
            case 3007:
                //串流结束
                _isStarting = false;
                [_startBtn setTitle:@"STREAMING" forState:UIControlStateNormal];
                break;
            case 3008:
                //码率信息回调: 总码率|视频码率|音频码率
                break;
            default:
                break;
        }
    });
    
}
- (IBAction)closeAction:(id)sender {
     [self dismissViewControllerAnimated:YES completion:nil];
}

@end
