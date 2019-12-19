//
//  HFComPouPriceCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/1/17.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFPaymentBaseModel.h"
NS_ASSUME_NONNULL_BEGIN
@class HFComPouPriceCell;
@protocol HFComPouPriceCellDelegate <NSObject>
- (void)didSelectAndUnselectFunction:(HFComPouPriceCell*)cell withModel:(HFCompouModel*)dataModel;
@end
@interface HFComPouPriceCell : UITableViewCell
@property (nonatomic,weak)id <HFComPouPriceCellDelegate>delegate;
@property(nonatomic,strong)HFCompouModel *compouModel;
- (void)dataSomthing;
@end

NS_ASSUME_NONNULL_END
