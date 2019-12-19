//
//  HFYHQCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFPaymentBaseModel.h"
@class HFYHQCell;
NS_ASSUME_NONNULL_BEGIN
@protocol HFYHQCellDelegate <NSObject>

- (void)yhqCell:(HFYHQCell*)cell model:(HFAvailableModel*)model;

@end
@interface HFYHQCell : UITableViewCell
@property(nonatomic,weak)id<HFYHQCellDelegate> delegate;
@property(nonatomic,strong)HFAvailableModel *model;

- (void)domessageSomething ;
@end

NS_ASSUME_NONNULL_END
