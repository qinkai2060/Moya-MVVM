//
//  VipGiltBagCollectionViewCell.h
//  HeMeiHui
//
//  Created by Tracy on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VipGiftShopModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface VipGiltBagCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) VipGiftShopModel * itemModel;
- (void)setUpShopModel:(VipGiftShopModel *)item withType:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
