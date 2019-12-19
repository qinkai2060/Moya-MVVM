//
//  VideoCommentBarView.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/4/23.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"
#import "DXFaceView.h"

@class VideoCommentToolBarView;

#define kInputTextViewMinHeight 36
#define kInputTextViewMaxHeight 150
#define kHorizontalPadding 8
#define kVerticalPadding 5
 
typedef void(^sendBtnClick)(NSString *sendStr);
typedef void(^commentThreeBtnClick)(NSInteger btnTag,NSString *sendStr);

@protocol CommentToolBarDelegate;

@interface VideoCommentToolBarView : UIView
@property (nonatomic, copy) sendBtnClick sendBtnClick;
@property (nonatomic, copy) commentThreeBtnClick commentBtnClick;

@property (nonatomic, weak) id <CommentToolBarDelegate> delegate;

@property (nonatomic, strong) UIButton *detailZanBtn; // 赞

/**
 *  操作栏背景图片
 */
@property (strong, nonatomic) UIImage *toolbarBackgroundImage;

/**
 *  背景图片
 */
@property (strong, nonatomic) UIImage *backgroundImage;

/**
 *  表情的附加页面
 */
@property (strong, nonatomic) UIView *faceView;

/**
 *  用于输入文本消息的输入框
 */
@property (strong, nonatomic) XHMessageTextView *inputTextView;

/**
 *  文字输入区域最大高度，必须 > KInputTextViewMinHeight(最小高度)并且 < KInputTextViewMaxHeight，否则设置无效
 */
@property (nonatomic) CGFloat maxTextInputViewHeight;

// 来自评论
@property (nonatomic, assign) BOOL isFromDetail;

// 是否来自跟帖
@property (nonatomic, assign) BOOL isFromGenTie;

/**
 *  初始化方法
 *
 *  @param frame      位置及大小
 *
 *  @return DXMessageToolBar
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  默认高度
 *
 *  @return 默认高度
 */
+ (CGFloat)defaultHeight;

@end


@protocol CommentToolBarDelegate <NSObject>

@optional

/**
 *  文字输入框开始编辑
 */
- (void)inputTextViewDidBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  文字输入框将要开始编辑
 */
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView;

/**
 *  发送文字消息，可能包含系统自带表情
 *
 *  @param text 文字消息
 */
- (void)didSendText:(NSString *)text;

/**
 *  发送第三方表情，不会添加到文字输入框中
 *
 *  @param faceLocalPath 选中的表情的本地路径
 */
- (void)didSendFace:(NSString *)faceLocalPath;

//输入结束
- (void)inputEndEditing;

@required
/**
 *  高度变到toHeight
 */
- (void)didChangeFrameToHeight:(CGFloat)toHeight;

@end

