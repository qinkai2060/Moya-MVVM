//
//  HFPayMentCell.h
//  housebank
//
//  Created by usermac on 2018/11/14.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFPaymentBaseModel.h"
@class HFPayMentCell;
NS_ASSUME_NONNULL_BEGIN

@protocol HFPayMentCellDelegate <NSObject>
@optional
- (void)textEndWithTextField:(NSString*)textField cell:(HFPayMentCell*)cell;
- (void)paymentCell:(HFPayMentCell*)cell model:(HFOrderShopModel*)model;

@end
@interface HFPayMentCell : UITableViewCell
@property (nonatomic,weak) id<HFPayMentCellDelegate> delegate;
@property (nonatomic,strong) HFOrderShopModel *model;
- (void)doMessageSomthing;
@end

NS_ASSUME_NONNULL_END
