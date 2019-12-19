//
//  AssembleSearchListViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/2.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "HMHBasePrimaryViewController.h"
#import "AssembleSearchListModel.h"
#import "SpGoodsDetailViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface AssembleSearchListViewController : SpBaseViewController
@property (nonatomic, strong) NSString *classId;
// 表示等级 1 2 3
@property (nonatomic, strong) NSString *level;
// 搜索文字
@property (nonatomic, strong) NSString *searchStr;

@property (nonatomic, assign) BOOL isFristIn;
@property (nonatomic, strong) AssembleSearchListModel *searchListModel;
@property (strong , nonatomic)NSString *spacEndDateTime;
@property (strong , nonatomic)NSString *spacStarDateTime;
@property (strong , nonatomic)NSString *spaceTime;//当前日期距离结束时间倒计时
@property (strong , nonatomic)NSString *starSpaceTime;//当前日期距离开始时间倒计时
@end

NS_ASSUME_NONNULL_END
