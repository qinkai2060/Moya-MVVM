//
//  HFPayMentViewModel.h
//  housebank
//
//  Created by usermac on 2018/11/13.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFViewModel.h"
#import "HFAddressModel.h"
#import "HFCommitPayModel.h"
@class HFPaymentBaseModel;
typedef  NS_ENUM(NSInteger,HFOrderFromType) {
    HFOrderShopModelTypeCar = 1,
    HFOrderShopModelTypeDetial = 2,
    HFOrderShopModelTypeVipPackage = 3,
};
NS_ASSUME_NONNULL_BEGIN

@interface HFPayMentViewModel : HFViewModel
@property (nonatomic,assign)HFOrderFromType contentType;
@property (nonatomic,strong)HFPaymentBaseModel *payMentModel;
@property (nonatomic,strong)HFCommitPayModel *commitPayModel;
@property(nonatomic,strong)HFAddressModel *addressmodel;

@property (nonatomic,strong)NSMutableArray *shopingList;
@property(nonatomic,strong)RACSubject *selectYHQSubjc;
/**
 进入地址管理操作
 */
@property(nonatomic,strong)RACSubject *enterAddressOrEditingSubj;

/**
 进入店铺操作
 */
@property(nonatomic,strong)RACSubject *enterStoreSubjc;

/**
 弹出抵扣券
 */
@property(nonatomic,strong)RACSubject *didSelectQuanSubjc;
/**
 选中券
 */
@property(nonatomic,strong)RACSubject *sendQuanSubjc;
/**
 获取价格信号和请求
 */
@property(nonatomic,strong)RACSubject *getAllPriceSubjc;
@property(nonatomic,strong)RACCommand *getAllPriceCommand;
/**
 提交订单操作
 */
@property(nonatomic,strong)RACSubject *commitSubjc;
/**
 地址信号和请求
 */
@property(nonatomic,strong)RACSubject *addressSubj;
@property(nonatomic,strong)RACCommand *getDetialAddressCommand;
/**
 订单数据信号和请求
 */
@property(nonatomic,strong)RACSubject *orderDetialSubjc;
@property(nonatomic,strong)RACCommand *getDetialOrderCommand;

/**
 获取运费信号和请求
 */
@property(nonatomic,strong)RACSubject *getPostAgeSubjc;
@property(nonatomic,strong)RACCommand *getPostPriceCommand;
/**
 新地址
 */
@property(nonatomic,strong)RACSubject *resetAddressSubjc;
/**
 提交订单信号和请求
 */
@property(nonatomic,strong)RACSubject *commitOrderSubjc;
@property(nonatomic,strong)RACCommand *commitOrderCommand;

@property(nonatomic,strong)RACSubject *showYHQSubjc;


/**
 拼团id
 */
@property(nonatomic,copy) NSString *tuanId;
/**
 购物车id
 */
@property(nonatomic,copy) NSString *shoppingcartId;
/**
 商品id
 */
@property(nonatomic,copy) NSString *commodityId;
/**
 是否激活
 */
@property(nonatomic,assign) NSInteger active;
/**
 立即购买商品数量
 */
@property(nonatomic,assign) NSInteger countNumber;
/**
 规格id
 */
@property(nonatomic,strong) NSString *specifications;
/**
 抵扣券
 */
@property(nonatomic,assign) CGFloat allRegisterAmount ;
/**
 抵扣券
 */
@property(nonatomic,assign) CGFloat allIntegralPrice;
/**
 运费
 */
@property(nonatomic,assign) CGFloat postage;
/**
 礼包运费
 */
@property(nonatomic,assign) CGFloat transportPrice;
/**
 该店铺下所有运费
 */
@property(nonatomic,assign) CGFloat shopAllPostage;
/**
 区域id
 */
@property(nonatomic,copy) NSString *regionId;
/**
 城市id
 */
@property(nonatomic,copy) NSString *cityId;
/**
 initOrder参数从立即购买过来
 */
@property(nonatomic,strong)NSDictionary *orderWriteParams;
/**
 请求总价参数从立即购买过来
 */
//@property(nonatomic,strong)NSDictionary *AllPriceParams;

//@property(nonatomic,strong)NSDictionary *getPostParms;

@property(nonatomic,strong)NSDictionary *addOrderParams;

@property(nonatomic,strong)NSArray *remarks;

@property(nonatomic,strong)NSDictionary *remarksDict;

@end

NS_ASSUME_NONNULL_END
