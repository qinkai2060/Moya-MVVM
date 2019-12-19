//
//  SpStoreInformationCell.h
//  housebank
//
//  Created by zhuchaoji on 2018/12/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpStoreInformationCell : UICollectionViewCell
@property (nonatomic, strong) GoodsDetailModel *productInfo;
-(void)reSetVDataValue:(GoodsDetailModel*)productInfo;
@end

NS_ASSUME_NONNULL_END
