//
//  HFPayMentShoppsCell.h
//  housebank
//
//  Created by usermac on 2018/11/14.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFPaymentBaseModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFPayMentShoppsCell : UITableViewCell
@property(nonatomic,strong)HFProuductModel *productModel;
- (void)doDataSomthing;
@end

NS_ASSUME_NONNULL_END
