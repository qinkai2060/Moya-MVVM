//
//  SpMainMineViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/24.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "CheckShopsModel.h"
#import "UserInfoModel.h"
#import "OrderStatusModel.h"
#import "AchievementModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpMainMineViewController : SpBaseViewController
@property(nonatomic,strong)CheckShopsModel *checkShopsModel;
@property(nonatomic,strong)UserInfoModel *userInfoModel;
@property(nonatomic,strong)OrderStatusModel *orderStatusModel;
@property(nonatomic,strong)AchievementModel *achievementModel;
@property(nonatomic,strong)NSString *isShow;
@property(nonatomic,strong)NSMutableArray * nameArray1;
@property(nonatomic,strong)NSMutableArray * imageArray1;
@property(nonatomic,strong)NSMutableArray * nameArray2;
@property(nonatomic,strong)NSMutableArray * imageArray2;
@property(nonatomic,strong)NSMutableArray * nameArray3;
@property(nonatomic,strong)NSMutableArray * imageArray3;
@property(nonatomic,assign)BOOL  ismyAssets;//是否我的资产

@end

NS_ASSUME_NONNULL_END
