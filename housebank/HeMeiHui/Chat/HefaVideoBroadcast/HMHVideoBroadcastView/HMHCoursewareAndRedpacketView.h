//
//  HMHCoursewareAndRedpacketView.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/12.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoRedPacketModel.h"

@class HMHCoursewareAndRedpacketView;
//协议
@protocol CoursewareAndRedpacketDelegate <NSObject>
@optional

/**
  课件按钮的点击事件
 */
- (void)pptBtnClickWithBtn:(UIButton *)pptBtn;

/**
  红包按钮的点击事件
 */
- (void)redPacketBtnClickWithBtn:(UIButton *)redPacketBtn;

@end

// 课件和红包view
@interface HMHCoursewareAndRedpacketView : UIView

@property (nonatomic, strong) UIButton *HMH_pptBtn; // 课件
@property (nonatomic, strong) UIButton *HMH_addBtn;
@property (nonatomic, strong) UIButton *HMH_redPacketBtn; // 红包btn

@property (nonatomic, weak) id<CoursewareAndRedpacketDelegate> delegate;

- (void)refreshUIWithCoursewareUrlArr:(NSMutableArray *)courseArr isFromTimeShift:(BOOL)isFromTimeShift redPacketWithModel:(HMHVideoRedPacketModel *)redModel;

@end
