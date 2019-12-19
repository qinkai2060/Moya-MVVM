//
//  ShopDetailTableViewCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/16.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ShopDetailTableViewCell : UITableViewCell
/**商品图片 */
@property (nonatomic,strong) UIImageView *pictureImg;
/* 内容 */
@property (strong , nonatomic)UILabel *contentLabel;
/* 商品现价 */
@property (strong , nonatomic)UILabel *currentPriceLabel;
/* 商品原价 */
@property (strong , nonatomic)UILabel *originalPriceLabel;
/* 购买数 */
@property (strong , nonatomic)UILabel *buyCountLabel;
@property (strong , nonatomic)PRODUCT_MODULEItem *productModeItem;

-(void)reSetVDataValue:(PRODUCT_MODULEItem*)productModel;
@end

NS_ASSUME_NONNULL_END
