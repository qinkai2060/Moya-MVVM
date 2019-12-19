//
//  HMHVideoPlayBottomView.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/4.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoListModel.h"
// 视频下方的黑色的view
@interface HMHVideoPlayBottomView : UIView

@property (nonatomic ,copy) void(^shouCangBtnClick)(NSInteger state);
@property (nonatomic, copy) void(^downloadBtnClick)();
// 收藏按钮
@property (nonatomic, strong) UIButton *shouCangBtn;

// 刷新时 判断是否来自直播 来自直播 是没有下载
- (void)refreshPlayerBottomViewWithModel:(HMHVideoListModel *)model isFromTimeLive:(BOOL)isFromTimeLive;

@end
