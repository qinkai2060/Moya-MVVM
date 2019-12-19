/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.键盘更多加号
 */

#import <UIKit/UIKit.h>
#import "GrayPageControl.h"
#import "ChatTypes.h"

@protocol DXChatBarMoreViewDelegate;
@interface DXChatBarMoreView : UIView <UIScrollViewDelegate>

@property (nonatomic,assign) id<DXChatBarMoreViewDelegate> delegate;

@property (nonatomic, strong) UIButton *photoButton;
@property (nonatomic, strong) UIButton *takePicButton;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *audioCallButton;

@property (nonatomic, strong) UIButton *collectionButton;
@property (nonatomic, strong) UIButton *couponsButton;

@property (nonatomic, strong) UIScrollView *chatMoreBgScrollerView;
@property (strong, nonatomic) GrayPageControl *pageControl;

- (instancetype)initWithFrame:(CGRect)frame option:(DXChatBarMoreItemOption)option;

- (void)setupSubviews:(DXChatBarMoreItemOption)option;

@end

@protocol DXChatBarMoreViewDelegate <NSObject>
@optional
- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView;
- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView;
- (void)moreViewVideoAction:(DXChatBarMoreView *)moreView;
- (void)moreViewAudioCallAction:(DXChatBarMoreView *)moreView;
- (void)moreViewCollectionAction:(DXChatBarMoreView *)moreView;
- (void)moreViewCouponsAction:(DXChatBarMoreView *)moreView;
- (void)moreViewRedPaperAction:(DXChatBarMoreView *)moreView;
- (void)moreViewSpreadAction:(DXChatBarMoreView *)moreView;
- (void)moreViewSpeakSkillAction:(DXChatBarMoreView *)moreView;
- (void)moreViewReceiptAction:(DXChatBarMoreView *)moreView;
@end
