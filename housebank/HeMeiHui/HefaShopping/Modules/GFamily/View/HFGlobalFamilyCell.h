//
//  HFGlobalFamilyCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/1.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFHotelDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFGlobalFamilyCell : UITableViewCell
@property(nonatomic,strong)HFHotelDataModel *model;
- (void)doMessageSommthing;
@end

NS_ASSUME_NONNULL_END
