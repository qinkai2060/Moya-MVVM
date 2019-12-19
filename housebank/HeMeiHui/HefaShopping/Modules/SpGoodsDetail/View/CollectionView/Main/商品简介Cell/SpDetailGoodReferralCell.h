//
//  SpDetailGoodReferralCell.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
typedef NS_ENUM(NSInteger , GoodsDetailStyle) {
    
    //普通商品
    GoodsDetailStyleNormal = 0,
    //秒杀商品
    GoodsDetailStyleSpike,
    //拼团商品
    GoodsDetailStyleAssemble
    
};
typedef NS_ENUM(NSInteger , GoodsDetailClickType) {
    
    //返利
    GoodsDetailClickTypeGiveProfit = 0,
    //批发可享
    GoodsDetailClickTypeWholesale,
    //领取优惠券
    GoodsDetailClickTypeGetCoupon
    
};

typedef void(^GoodsDetailClickBlock)(GoodsDetailClickType clickType);

@interface SpDetailGoodReferralCell : UICollectionViewCell
@property (nonatomic, copy) GoodsDetailClickBlock clickBlock;
//新增类型
@property (nonatomic ,assign) GoodsDetailStyle goodsStyle;
@property (strong , nonatomic)NSString *spaceTime;
/* 商品现价 */
@property (strong , nonatomic)UILabel *currentPriceLabel;
/* 商品原价 */
@property (strong , nonatomic)UILabel *originalPriceLabel;
/* 店铺标记 *///暂时没用
@property (strong , nonatomic)UILabel *shopMarkLabel;
/* 商品标题 */
@property (strong , nonatomic)UILabel *titleLabel;
/* 商品小标题 *///暂时没用
@property (strong , nonatomic)UILabel *subtitleLabel;
/*月销*/
@property (strong , nonatomic)UILabel *monthlySalesLabel;

/**
 vip返利
 */
@property (strong , nonatomic)UIButton *vipFlBtn;

/**
 领取优惠券
 */
@property (strong , nonatomic)UIView *vipGetCoupon;

/**
 单件最低
 */
@property (strong , nonatomic)UILabel *minimumUnitPrice;

/*发货地*/
@property (strong , nonatomic)UILabel *addressLabel;
/* 咨询 */
@property (strong , nonatomic)UIButton *consultationBtn;

/* 优惠按钮 *///暂时没用
@property (strong , nonatomic)UIButton *preferentialButton;
@property (strong , nonatomic)UIImage *image;
@property (strong , nonatomic)UILabel *label;
@property (nonatomic,strong)NSString *code;
@property (nonatomic,strong)NSString *skuItemPrice;
@property (nonatomic,strong)NSString *skuItemIntrinsicPrice;


/** 分享按钮点击回调 *///暂时没用
@property (nonatomic, copy) dispatch_block_t shareButtonClickBlock;
@property (nonatomic, strong) Product *productInfo;
-(void)reSetVDataValue:(Product*)productInfo  allData:(GoodsDetailModel*)goodDetail;
@end
