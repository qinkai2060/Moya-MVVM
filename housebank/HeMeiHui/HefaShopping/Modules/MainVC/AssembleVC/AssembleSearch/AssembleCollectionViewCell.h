//
//  AssembleCollectionViewCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZJJTimeCountDown.h"
#import "ZJJTimeCountDownDateTool.h"
#import "AssembleSearchListModel.h"

NS_ASSUME_NONNULL_BEGIN
@class AssembleCollectionViewCell;
// 进店
typedef void(^toShopBtnClick)(AssembleCollectionViewCell *cell,NSInteger cellIndexRow);
typedef NS_ENUM(NSInteger , ChangeType) {
    
    //正在进行
    UnderwayType= 0,
    //即将开始
    WillBeginType,
    //已结束
    EndType,
    
    
};
@interface AssembleCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) toShopBtnClick toShopBtnClickBlock;
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
@property (strong , nonatomic)NSString *spacStarDateTime;
@property (strong , nonatomic)NSString *spaceTime;//当前日期距离结束时间倒计时
@property (strong , nonatomic)NSString *starSpaceTime;//当前日期距离开始时间倒计时
- (void)refreshCellWithModel:(id)model;
@end

NS_ASSUME_NONNULL_END
