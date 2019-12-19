//
//  HFPriceFilterCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFilterPriceModel.h"
@class  HFPriceFilterCell;
NS_ASSUME_NONNULL_BEGIN
@protocol HFPriceFilterCellDelegate <NSObject>

- (void)priceFilterCell:(HFPriceFilterCell*)cell model:(HFFilterPriceModel*)model;

@end
@interface HFPriceFilterCell : UITableViewCell
@property(nonatomic,weak)id <HFPriceFilterCellDelegate> delegate;
@property(nonatomic,strong)HFFilterPriceModel *pricefilterModel;
- (void)doMessageSomthing ;
@end

NS_ASSUME_NONNULL_END
