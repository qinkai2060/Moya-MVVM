//
//  HFYDDetialViewModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewModel.h"
#import "HFYDDetialDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFYDDetialViewModel : HFViewModel
@property(nonatomic,assign)CLLocationCoordinate2D usercoordinate;
@property(nonatomic,assign)CLLocationCoordinate2D shopcoordinate;
@property(nonatomic,copy)NSString *pageTage;
/**
 微店列表请求
 */
@property(nonatomic,strong)RACCommand *wdDataCommand;
@property(nonatomic,strong)RACSubject *wdDataSubjc;
/**
 购物车列表
 */
@property(nonatomic,strong)RACSubject *selectCarSubjc;
/**
 购物车列表请求
 */
@property(nonatomic,strong)RACCommand *selectCarCommand;


/**
 查询商品规格回调
 */
@property(nonatomic,strong)RACSubject *selectSpecialIDSubjc;

/**
 选泽规格发送数据
 */
@property(nonatomic,strong)RACSubject *sendSelectedDataSubjc;
@property(nonatomic,assign)NSInteger productId;
/**
 查询商品规格
 */
@property(nonatomic,strong)RACCommand *selectSpecialIDCommand;

/**
 添加商品到购物车
 */
@property(nonatomic,strong)HFYDDetialRightDataModel *rightModel;
/**
 添加或减少购物车状态回调
 */
@property(nonatomic,strong)RACSubject *addOrminCarSubjc;
/**
 添加或减少购物车
 */
@property(nonatomic,strong)RACCommand *addOrminCarCommand;

/**
 云店关注参数
 */
@property(nonatomic,assign)BOOL isFollow;
@property(nonatomic,copy)NSString *shopId;
@property(nonatomic,strong)RACSubject *enterMapSubjc;
//@property(nonatomic,strong)RACCommand *getShopfollowCommand;
/**
 云店关注操作
 */
@property(nonatomic,strong)RACCommand *ydfollowCommand;

/**
 云店关注操作
 */
@property(nonatomic,strong)RACSubject *ydfollowSubjc;

/**
 登录操作
 */
@property(nonatomic,strong)RACSubject *loginSubjc;
/**
 云店点评详情页
 */
@property(nonatomic,strong)RACCommand *ydDataCommand;

/**
 云店详情页数据
 */
@property(nonatomic,strong)RACSubject *ydDataSubjc;
/**
 滚动
 */
@property (nonatomic,strong)RACSubject *canscrollSubjc;

/**
 评价页滚动
 */
@property (nonatomic,strong)RACSubject *appcanscrollSubjc;
/**
 子View滚动
 */
@property (nonatomic,strong)RACSubject *subCanSubjc;

/**
 进入微店
 */
@property (nonatomic,strong)RACSubject *enterWDSubjc;

/**
 点击评价
 */
@property (nonatomic,strong)RACSubject *didApprriaseSubjc;

/**
 点击商品
 */
@property (nonatomic,strong)RACSubject *didProductSubjc;

@property (nonatomic,strong)HFYDCarModel *carModel;
@property (nonatomic,strong)HFYDDetialDataModel *detialModel;
@property (nonatomic,strong)RACCommand *shareCommand;
@property (nonatomic,strong)RACSubject *shareSubjc;
- (RACSignal *)create_shopQrcode:(NSString *)shopID shopType:(NSString *)shopType;
@end

NS_ASSUME_NONNULL_END
