//
//  LivePlayer.h
//  NodeMediaClient v0.5.3
//
//  Created by Mingliang Chen on 15/8/21.
//  Copyright (c) 2015年 NodeMedia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LivePlayerDelegate

-(void) onEventCallback:(int)event msg:(NSString*)msg;

@end


@interface LivePlayer : NSObject

@property (nonatomic) int bufferTime;
@property (nonatomic) int maxBufferTime;
@property (nonatomic, weak) id<LivePlayerDelegate> livePlayerDelegate;

-(int) setUIView:(UIView*)playVideoView ContentMode:(UIViewContentMode)contentMode;
-(int) startPlay:(NSString*)rtmpUrl;
-(int) startPlayRtmpUrl:(NSString*)rtmpUrl pageUrl:(NSString*)pageUrl swfUrl:(NSString*)swfUrl;
-(int) stopPlay;
-(BOOL) capturePicture:(NSString*)filePath;
-(int) getBufferLength;
@end
