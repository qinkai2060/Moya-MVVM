//
//  SpBusinessDetailCell.h
//  housebank
//
//  Created by zhuchaoji on 2018/12/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpBusinessDetailCell : UICollectionViewCell

/* 商铺图片*/
@property (strong , nonatomic)UIImageView *storeIcon;
/* 商铺名称 */
@property (strong , nonatomic)UILabel *storeName;
/* 店铺标记 */
@property (strong , nonatomic)UILabel *shopMarkLabel;
/* 联系商家 */
@property (strong,nonatomic)UIButton *contactBtn;
/* 进店逛逛 */
@property (strong,nonatomic)UIButton *aroundBtn;
/* 产品描述 */
@property (strong , nonatomic)UILabel *descriptionLabel;
/* 买家服务 */
@property (strong , nonatomic)UILabel *serviceLabel;
/*物流服务*/
@property (strong , nonatomic)UILabel *logisticsLable;
/* 联系商家 */
@property(nonatomic,strong)RACSubject *contactMerchantAction;
/* 联系商家 */
@property(nonatomic,strong)RACSubject *shopAroundAction;
@property (nonatomic, strong) GoodsDetailModel *productInfo;
-(void)reSetVDataValue:(GoodsDetailModel*)productInfo;
@end

NS_ASSUME_NONNULL_END
