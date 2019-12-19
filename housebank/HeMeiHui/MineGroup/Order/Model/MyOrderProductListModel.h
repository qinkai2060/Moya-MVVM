//
//  MyOrderProductListModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/5/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderProductListModel : NSObject
@property (nonatomic, strong) NSNumber *product_id;
@property (nonatomic, copy) NSString *productName;//商品名
@property (nonatomic, strong) NSNumber *productCount;//产品数量
@property (nonatomic, strong) NSNumber *salePrice;//销售价
@property (nonatomic, copy) NSString *productSubtitle;//子标题
@property (nonatomic, copy) NSString *specifications;//商品规格
@property (nonatomic, copy) NSString *imagePath;//图片
@property (nonatomic, strong) NSNumber *productLevel; //1 1类 2 2类 3 3类
@property (nonatomic, strong) NSNumber *priceType;//==4 显示促销
@property (nonatomic, strong) NSString *orderBizCategory;//订单业务类型
@property (nonatomic, strong) NSNumber *arbitrateState;//退款状态，0默认，1=退款待仲裁，2=拒绝退款，3=退款中，4=已退款
@property (nonatomic, strong) NSNumber *orderState;
@property (nonatomic, strong) NSNumber *state;//0有效 1取消 2同意
@end

NS_ASSUME_NONNULL_END
