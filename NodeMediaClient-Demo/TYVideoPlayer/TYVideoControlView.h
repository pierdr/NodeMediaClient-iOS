//
//  TYPlayerControlView.h
//  TYVideoPlayerDemo
//
//  Created by tany on 16/7/5.
//  Copyright © 2016年 tany. All rights reserved.
//  播放器控制层

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TYVideoControlEvent) {
    TYVideoControlEventBack,
    TYVideoControlEventNormalScreen,
    TYVideoControlEventFullScreen,
    TYVideoControlEventPlay,
    TYVideoControlEventSuspend,
    TYVideoControlEventRefresh
};

typedef NS_ENUM(NSUInteger, TYSliderState) {
    TYSliderStateBegin,
    TYSliderStateDraging,
    TYSliderStateEnd,
};

@class TYVideoControlView;
@protocol TYVideoControlViewDelegate <NSObject>

@optional

- (void)videoControlView:(TYVideoControlView *)videoControlView recieveControlEvent:(TYVideoControlEvent)event;

- (void)videoControlView:(TYVideoControlView *)videoControlView state:(TYSliderState) state sliderToProgress:(CGFloat)progress;

@end

@interface TYVideoControlView : UIView

@property (nonatomic, weak) id<TYVideoControlViewDelegate> delegate;

// setter

- (void)setTitle:(NSString *)title;

- (void)setTotalVideoTime:(NSString *)time;

- (void)setCurrentVideoTime:(NSString *)time;

- (void)setSliderProgress:(CGFloat)progress;

- (void)setBufferProgress:(CGFloat)progress;

- (void)setFullScreen:(BOOL)fullScreen;

- (void)setPlayBtnState:(BOOL)isPlayState;

// hiden

- (BOOL)contentViewHidden;

- (void)setContentViewHidden:(BOOL)hidden; // 是否隐藏控制层View

- (void)setContentViewHiddenWithDelay:(int)delayMsec;

- (void)setTimeSliderHidden:(BOOL)hidden; // 是否隐藏 slider 和 time label

- (void)setPlayBtnHidden:(BOOL)hidden; // 是否隐藏 播放和暂停按钮

- (void)setLoadingViewHidden:(BOOL)hidden; //是否隐藏加载视图

@end
