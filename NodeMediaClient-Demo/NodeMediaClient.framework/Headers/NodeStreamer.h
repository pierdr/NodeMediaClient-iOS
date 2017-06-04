//
//  NodeStreamer.h
//  NodeMediaClient
//
//  Created by Mingliang Chen on 16/9/8.
//  Copyright © 2016年 NodeMedia. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NodeStreamerDelegate

-(void) onEventCallback:(id)sender event:(int)event msg:(NSString*)msg;

@end

@interface NodeStreamer : NSObject

@property (nonatomic, weak) id<NodeStreamerDelegate> nodeStreamerDelegate;
///开始以视频原始帧率进行串流,多用于输入为本地文件或点播地址
-(int) startNativeRateStreaming:(NSString*)inputUrl output:(NSString*)outputUrl;

///开始串流
-(int) startStreamingWithInput:(NSString*)inputUrl output:(NSString*)outputUrl;

///停止串流
-(int) stopStreaming;

@end
