//
//  AssembleCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/21.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJJTimeCountDown.h"
#import "ZJJTimeCountDownDateTool.h"
#import "AssembleListModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger , ChangeType) {
    
    //正在进行
    UnderwayType= 0,
    //即将开始
    WillBeginType,
    //已结束
    EndType,
    
    
};
@interface AssembleCell : UITableViewCell
//新增类型
@property (nonatomic ,assign) ChangeType changeType;
@property (nonatomic, strong) UIImageView *HMH_iconImage;
@property (nonatomic, strong) UILabel *timerLable;
@property (nonatomic, strong) UILabel *timerAlterLable;
@property (nonatomic, strong) UILabel *HMH_titleLab;
@property (nonatomic, strong) UILabel *HMH_subLab;
@property (nonatomic, strong) UILabel *tagLable;
@property (nonatomic, strong) UILabel *HMH_subscribeNumLab;
@property (nonatomic, strong) UILabel *HMH_contentNumLab;
@property (nonatomic, strong) UIButton *HMH_subscribeBtn;
@property (nonatomic ,strong) ZJJTimeCountDownLabel *twoTimeLabel;
@property (nonatomic ,strong) ZJJTimeCountDown *countDown;
@property (nonatomic ,strong) UILabel *lineLable;
@property (strong , nonatomic)NSString *spacEndDateTime;
@property (strong , nonatomic)NSString *spaceTime;
- (void)refreshCellWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
