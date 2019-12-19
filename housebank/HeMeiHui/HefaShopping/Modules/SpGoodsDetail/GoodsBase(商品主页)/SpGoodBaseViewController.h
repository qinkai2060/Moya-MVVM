//
//  SpGoodBaseViewController.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "CommentListModel.h"
#import "GoodsDetailModel.h"
#import "CommentListModel.h"
#import "ProductFeatureModel.h"
#import "SaveShoppingCar.h"
#import "GetProductListByConditionModel.h"
#import "SptimeKillProgressView.h"
//#import  "SpGoodsDetailViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger , GoodsBaseDetailStyle) {
    
    //普通商品
    OrdinaryGoodsBaseDetailStyle= 0,
    //直供精品 必须配合isVipGiftPackage来判断!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    DirectSupplyGoodsBaseDetailStyle,
    //促销商品
    PromotionGoodsBaseDetailStyle,
    //秒杀商品
    SpikeGoodsBaseDetailStyle,
    //拼团商品
    AssembleGoodsBaseDetailStyle,
    
    
};
typedef NS_ENUM(NSInteger , OffSetStyle) {
    
    //商品
    OffSetStyleGood = 0,
    //评价
    OffSetStyleComment,
    //详情
    OffSetStyledDetail,
 
    
    
};
typedef void(^SpGoodBaseViewControllerOffSetBlock)(OffSetStyle indexStyle);
@protocol SpGoodBaseViewDelegate <NSObject>
-(void)resetThirdNavBar:(CGFloat)offsetY;
-(void)reloadViewAndData;
@end
@interface SpGoodBaseViewController : SpBaseViewController
@property (nonatomic, copy) SpGoodBaseViewControllerOffSetBlock offSetBlock;
@property(nonatomic,weak)id<SpGoodBaseViewDelegate> Delegate;
/** 更改标题 */
@property (nonatomic , copy) void(^changeTitleBlock)(BOOL isChange);
//增加类型
@property (nonatomic ,assign) GoodsBaseDetailStyle goodsBaseStyle;
@property (nonatomic, assign) BOOL isVipGiftPackage;//是否为vip礼包

/* 商品标题 */
@property (strong , nonatomic)NSString *goodTitle;
/* 商品价格 */
@property (strong , nonatomic)NSString *goodPrice;
/* 商品小标题 */
@property (strong , nonatomic)NSString *goodSubtitle;
/* 商品图片 */
@property (strong , nonatomic)NSString *goodImageView;

/* 商品轮播图 */
@property (copy , nonatomic)NSArray *shufflingArray;
@property (strong, nonatomic) UICollectionView *collectionView;
/* 父控制器*/
//@property (strong, nonatomic) UIScrollView *scrollerView;
@property (nonatomic, strong) GoodsDetailModel *detailModel;
@property (nonatomic, strong) GetProductListByConditionModel *listModel;
@property (nonatomic, strong) CommentListModel *commentList;
@property (nonatomic, strong) ProductFeatureModel *featureModel;
@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *skuItemPrice;
@property (nonatomic,strong)NSString *skuItemIntrinsicPrice;
@property (strong , nonatomic)NSString *spacEndDateTime;
@property (strong , nonatomic)NSString *spaceTime;
@property (strong , nonatomic)NSString *spaceStartTime;
@property (strong , nonatomic)NSString *starSpaceTime;
@property (strong , nonatomic)UIView *TimeView;
@property (strong , nonatomic)UILabel *  lable1;
@property (strong , nonatomic)UILabel *  lable2;
@property (strong , nonatomic)UILabel *  lable3;
@property (strong , nonatomic)UILabel *  lable4;
@property (strong , nonatomic)UILabel *  lable5;
@property (strong , nonatomic)UIImageView *spikeTimerView;
@property (strong , nonatomic)SptimeKillProgressView * progressView;
@property (nonatomic, assign) NSInteger lastcontentOffset;//添加此属性的作用，根据差值，判断ScrollView是上滑还是下拉

@property (assign , nonatomic)CGFloat wkwebviewHeight;
@property (assign , nonatomic)BOOL isFirstRefrenshWeb;//web已经加载

@end

NS_ASSUME_NONNULL_END
