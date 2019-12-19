//
//  SpStoreRecommendDetailCell.h
//  housebank
//
//  Created by zhuchaoji on 2018/12/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpStoreRecommendDetailCell : UICollectionViewCell
/* 商铺图片*/
@property (strong , nonatomic)UIImageView *goodsImageView;
/* 商铺名称 */
@property (strong , nonatomic)UILabel *goodsName;

/* 商品现价 */
@property (strong , nonatomic)UILabel *currentPriceLabel;
/* 商品原价 */
@property (strong , nonatomic)UILabel *originalPriceLabel;
@property (nonatomic, strong) TopProductsItem *productInfo;
-(void)reSetVDataValue:(TopProductsItem*)productInfo;
@end

NS_ASSUME_NONNULL_END
