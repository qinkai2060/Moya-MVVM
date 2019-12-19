//
//  SpCommentDetailToolBar.h
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"
#import "DXFaceView.h"

NS_ASSUME_NONNULL_BEGIN
@class SpCommentDetailToolBar;

#define kInputTextViewMinHeight 33
#define kInputTextViewMaxHeight 150
#define kHorizontalPadding 8
#define kVerticalPadding 5

typedef void(^sendBtnClick)(NSString *sendStr);
typedef void(^commentThreeBtnClick)(NSInteger btnTag);

@protocol SpCommentDetailToolBarDelegate;

@interface SpCommentDetailToolBar : UIView


@property (nonatomic, copy) sendBtnClick sendBtnClick;
//@property (nonatomic, copy) commentThreeBtnClick commentBtnClick;

@property (nonatomic, weak) id <SpCommentDetailToolBarDelegate> delegate;

//@property (nonatomic, strong) HeFaCircleOfFriendModel *heFaModel;

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

// 是否来自合友圈详情界面
//@property (nonatomic, assign) BOOL isFromDetail;

// 刷新赞按钮的状态
//- (void)refreshZanBtnWithModel:(HeFaCircleOfFriendModel *)heFaModel;

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


@protocol SpCommentDetailToolBarDelegate <NSObject>

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

NS_ASSUME_NONNULL_END
