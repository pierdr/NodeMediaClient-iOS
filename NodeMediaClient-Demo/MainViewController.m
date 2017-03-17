//
//  MainViewController.m
//  NodeMediaClient-Demo
//
//  Created by Mingliang Chen on 17/2/6.
//  Copyright © 2017年 Mingliang Chen. All rights reserved.
//

#import "MainViewController.h"
#import "DefConfig.h"

@interface MainViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *livePlayUrlTF;
@property (weak, nonatomic) IBOutlet UITextField *livePlayBTTF;
@property (weak, nonatomic) IBOutlet UITextField *livePlayMBTTF;
@property (weak, nonatomic) IBOutlet UITextField *livePublishUrlTF;
@property (weak, nonatomic) IBOutlet UITextField *vodPlayUrlTF;
@property (weak, nonatomic) IBOutlet UITextField *vodPlayBTTF;
@property (weak, nonatomic) IBOutlet UITextField *vodPlayMBTTF;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_livePlayUrlTF setDelegate:self];
    [_livePlayBTTF setDelegate:self];
    [_livePlayMBTTF setDelegate:self];
    [_livePublishUrlTF setDelegate:self];
    [_vodPlayUrlTF setDelegate:self];
    [_vodPlayBTTF setDelegate:self];
    [_vodPlayMBTTF setDelegate:self];
    
    NSString *playUrl = [[DefConfig sharedInstance] getPlayUrl];
    if(playUrl != nil) {
        _livePlayUrlTF.text =playUrl;
    }
    
    NSString *publishUrl = [[DefConfig sharedInstance] getPublishUrl];
    if(publishUrl != nil) {
        _livePublishUrlTF.text = publishUrl;
    }
    
    int bt = [[DefConfig sharedInstance] getBufferTime];
    if(bt > 0) {
        _livePlayBTTF.text = [NSString stringWithFormat:@"%d",bt];
    }
    
    int mbt = [[DefConfig sharedInstance] getMaxBufferTime];
    if(mbt > 0) {
        _livePlayMBTTF.text = [NSString stringWithFormat:@"%d",mbt];
    }
    
    NSString *vodPlayUrl = [[DefConfig sharedInstance] getVodPlayUrl];
    if(vodPlayUrl != nil) {
        _vodPlayUrlTF.text = vodPlayUrl;
    }
    
    int vbt = [[DefConfig sharedInstance] getVodBufferTime];
    if(vbt > 0) {
        _vodPlayBTTF.text = [NSString stringWithFormat:@"%d",vbt];
    }
    
    int vmbt = [[DefConfig sharedInstance] getVodMaxBufferTime];
    if(vmbt > 0) {
        _vodPlayMBTTF.text = [NSString stringWithFormat:@"%d",vmbt];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [[DefConfig sharedInstance] putPlayUrl:_livePlayUrlTF.text];
    [[DefConfig sharedInstance] putPublishUrl:_livePublishUrlTF.text];
    [[DefConfig sharedInstance] putBufferTime:[_livePlayBTTF.text intValue]];
    [[DefConfig sharedInstance] putMaxBufferTime:[_livePlayMBTTF.text intValue]];
    [[DefConfig sharedInstance] putVodPlayUrl:_vodPlayUrlTF.text];
    [[DefConfig sharedInstance] putVodBufferTime:[_vodPlayBTTF.text intValue]];
    [[DefConfig sharedInstance] putVodMaxBufferTime:[_vodPlayMBTTF.text intValue]];
}

@end
