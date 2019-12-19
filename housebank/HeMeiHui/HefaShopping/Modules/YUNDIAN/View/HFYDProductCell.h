//
//  HFYDProductCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFYDDetialDataModel.h"
@class HFYDProductCell;
NS_ASSUME_NONNULL_BEGIN
@protocol HFYDProductCellDelegate <NSObject>
- (void)productCell:(HFYDProductCell*)cell data:(HFYDDetialRightDataModel*)model;
- (void)productCell:(HFYDProductCell*)cell loginStatus:(BOOL)islogin;
- (void)productCell:(HFYDProductCell*)cell selectproductSpecifications:(HFYDDetialRightDataModel*)model;
@end
@interface HFYDProductCell : UITableViewCell
@property(nonatomic,weak)id<HFYDProductCellDelegate>  delegate;
@property(nonatomic,strong)HFYDDetialRightDataModel *model;
- (void)doMessageSomething;
@end

NS_ASSUME_NONNULL_END
