//
//  YunDianNewRefundOrderProductModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YunDianNewRefundOrderProductModel : NSObject
@property (nonatomic, copy) NSString *productName;//商品名
@property (nonatomic, strong) NSNumber *salePrice;//商品销售价
@property (nonatomic, copy) NSString *specifications;//商品规格
@property (nonatomic, copy) NSString *productSubtitle;//商品副标题
@property (nonatomic, strong) NSNumber *productLevel;//商品等级
@property (nonatomic, strong) NSNumber *productCount;//商品数量
@property (nonatomic, copy) NSString *imagePath;//商品图片
@property (nonatomic, copy) NSString *jointPicture;//商品剪辑图片

@end

NS_ASSUME_NONNULL_END
