//
//  YunDianOrderProductsModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunDianOrderProductsModel : NSObject
@property (nonatomic, copy) NSString * productName; //商品名称
@property (nonatomic, copy) NSString * productSubtitle; //商品副标题
@property (nonatomic, copy) NSString * specifications; //商品规格（code1-code2...）
@property (nonatomic, copy) NSString * imagePath; //商品图片
@property (nonatomic, copy) NSString * jointPicture; //商品图片裁剪
@property (nonatomic, strong) NSNumber * productLevel; //商品等级
@property (nonatomic, strong) NSNumber * salePrice; //销售价
@property (nonatomic, strong) NSNumber * productCount; //商品数量
@property (nonatomic, strong) NSNumber *returnState;//默认先判断退款状态（正常状态该字段为空），退款状态，1=退款中，2=取消退款，3=拒绝退款，4=已退款
@property (nonatomic, copy) NSString *orderReturnId;//退款id;
@property (nonatomic, copy) NSString *refundNo;//新的退款编号

@end

NS_ASSUME_NONNULL_END
