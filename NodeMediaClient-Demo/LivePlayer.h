//
//  LivePlayer.h
//  NodeMediaClient v0.5.1
//
//  Created by Mingliang Chen on 15/8/21.
//  Copyright (c) 2015年 NodeMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define PLAY_MODE_LINEAL  0
#define PLAY_MODE_REALTIME  1


@protocol LivePlayerDelegate

-(void) onEventCallback:(int)event msg:(NSString*)msg;

@end


@interface LivePlayer : NSObject

@property (nonatomic) int bufferTime; //本地播放缓冲时长 单位毫秒
@property (nonatomic, weak) id<LivePlayerDelegate> livePlayerDelegate;

-(int) setUIView:(UIView*)playVideoView ContentMode:(UIViewContentMode)contentMode;
-(int) startPlay:(NSString*)rtmpUrl;
-(int) startPlayRtmpUrl:(NSString*)rtmpUrl pageUrl:(NSString*)pageUrl swfUrl:(NSString*)swfUrl;
-(int) stopPlay;
-(void) didActive:(bool)active;
@end
