//
//  SpGoodsDetailViewController.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "GetProductListByConditionModel.h"
#import "GoodsDetailModel.h"
#import "CommentListModel.h"
#import "ProductFeatureModel.h"
#import "SaveShoppingCar.h"
#import "SpGoodBaseViewController.h"
#import "SpGoodCommentViewController.h"
#import "SpGoodParticularsViewController.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger , GoodsDetailType) {
    
    //普通商品
    OrdinaryGoodsDetailStyle= 0,
    //直供精品 VIP礼包(需判断isVipGiftPackage)
    DirectSupplyGoodsDetailStyle,
    //促销商品
    PromotionGoodsDetailStyle,
    //秒杀商品
    SpikeGoodsDetailStyle,
    //拼团商品
    AssembleGoodsDetailStyle,
    //Vip批发商品
    VipWholesaleGoodsDetailStyle,
    
    
};
@interface SpGoodsDetailViewController : SpBaseViewController

@property (nonatomic, assign) BOOL isVipGiftPackage;//是否为vip礼包
//新增类型
@property (nonatomic ,assign) GoodsDetailType goodsType;
/* 商品标题 */
@property (strong , nonatomic)NSString *goodTitle;
/* 商品价格 */
@property (strong , nonatomic)NSString *goodPrice;
/* 商品小标题 */
@property (strong , nonatomic)NSString *goodSubtitle;
/* 商品图片 */
@property (strong , nonatomic)NSString *goodImageView;

@property (nonatomic, strong) GetProductListByConditionModel *listModel;
@property (nonatomic, strong)NSString * productId;

/* 商品轮播图 */
@property (copy , nonatomic)NSArray *shufflingArray;

@property (nonatomic, strong) SpGoodBaseViewController *goodBaseVc;
@property (nonatomic, strong) SpGoodCommentViewController *goodCommentVc;
/* 通知 */
@property (weak ,nonatomic) id dcObj;
@property (nonatomic, strong) NSMutableArray *selectImageTap;
@property (nonatomic, strong) GoodsDetailModel *detailModel;
@property (nonatomic, strong) CommentListModel *commentList;
@property (nonatomic, strong)  ProductFeatureModel *featureModel;
@property (nonatomic, strong)  SaveShoppingCar *saveShoppingCar;
@property (strong , nonatomic)NSString *spacEndDateTime;
@property (strong , nonatomic)NSString *spaceTime;
@property (strong , nonatomic)NSString *spaceStartTime;
@property (strong , nonatomic)NSString *starSpaceTime;
@property (nonatomic,strong)NSString *code;
- (instancetype)initWithModel:(GetProductListByConditionModel*)model;

-(void)resetThirdNavBar:(CGFloat)offsetY;
@end

NS_ASSUME_NONNULL_END
