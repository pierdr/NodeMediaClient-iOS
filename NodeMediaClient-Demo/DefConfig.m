//
//  DefConfig.m
//  NodeMediaClient-Demo
//
//  Created by Mingliang Chen on 15/8/30.
//  Copyright (c) 2015年 NodeMedia. All rights reserved.
//

#import "DefConfig.h"

@interface DefConfig()
@property (strong, nonatomic) NSUserDefaults *defaults;
@end

@implementation DefConfig

+(DefConfig*)sharedInstance {
    static DefConfig *defConfig;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        defConfig = [[DefConfig alloc] init];
        defConfig.defaults = [NSUserDefaults standardUserDefaults];
    });
    return defConfig;
}

-(void)putPlayUrl:(NSString*)playUrl {
    [self.defaults setObject:playUrl forKey:@"playUrl"];
    [self.defaults synchronize];
}

-(void)putPublishUrl:(NSString*)publishUrl {

    [self.defaults setObject:publishUrl forKey:@"publishUrl"];
    [self.defaults synchronize];
}

-(void)putBufferTime:(int)bufferTime {
    [self.defaults setObject:@(bufferTime) forKey:@"bufferTime"];
    [self.defaults synchronize];
}

-(void)putMaxBufferTime:(int)maxBufferTime {
    [self.defaults setObject:@(maxBufferTime) forKey:@"maxBufferTime"];
    [self.defaults synchronize];
}

-(void)putVodPlayUrl:(NSString*)vodPlayUrl {
    [self.defaults setObject:vodPlayUrl forKey:@"vodPlayUrl"];
    [self.defaults synchronize];
}

-(void)putVodBufferTime:(int)vodBufferTime {
    [self.defaults setObject:@(vodBufferTime) forKey:@"vodBufferTime"];
    [self.defaults synchronize];
}

-(void)putVodMaxBufferTime:(int)vodMaxBufferTime {
    [self.defaults setObject:@(vodMaxBufferTime) forKey:@"vodMaxBufferTime"];
    [self.defaults synchronize];
}


-(NSString*)getPlayUrl {
    return [self.defaults stringForKey:@"playUrl"];
}

-(NSString*)getPublishUrl {
    return [self.defaults stringForKey:@"publishUrl"];
}

-(int)getBufferTime {
    return [[self.defaults valueForKey:@"bufferTime"] intValue];
}

-(int)getMaxBufferTime {
    return [[self.defaults valueForKey:@"maxBufferTime"] intValue];
}

-(NSString*)getVodPlayUrl {
     return [self.defaults stringForKey:@"vodPlayUrl"];
}

-(int)getVodBufferTime {
     return [[self.defaults valueForKey:@"vodBufferTime"] intValue];
}

-(int)getVodMaxBufferTime {
     return [[self.defaults valueForKey:@"vodMaxBufferTime"] intValue];
}
@end
