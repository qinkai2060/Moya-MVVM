//
//  HMHGloblaHomeViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/6.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^appearBlock)(void);
@interface HMHGloblaHomeViewController : SpBaseViewController
@property (nonatomic, strong) NSMutableArray *dataSourceArr;//城市对应ID
@property(nonatomic,strong) UIView *titleView;
@property (nonatomic,assign)NSInteger startDate;// 选中开始时间
@property (nonatomic,assign)NSInteger endDate;// 选中结束时间
@property(nonatomic,strong) NSString *cityName;//城市名字
@property(nonatomic,strong) NSString *cityId;//城市id
@property(nonatomic,strong) NSString *pointLng;//经度
@property(nonatomic,strong) NSString *pointLat;//纬度
@property(nonatomic,strong) NSString *dateStar;//开始日期
@property(nonatomic,strong) NSString *dateEnd;//结束日期
@property(nonatomic,strong) NSString *keyWord;//关键字
@property(nonatomic,strong) NSString *minPrice;//最小价格
@property(nonatomic,strong) NSString *maxPrice;//最大价格
@property(nonatomic,strong) NSString *star;//星级
@property (nonatomic, copy) appearBlock appearblock;
@property(nonatomic,assign) BOOL isPushList;//是否push到list
@property(nonatomic,strong) NSDictionary *pushListDic;

@end

NS_ASSUME_NONNULL_END
