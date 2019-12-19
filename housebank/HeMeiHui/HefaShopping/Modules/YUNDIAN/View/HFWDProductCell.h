//
//  HFWDProductCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFYDDetialDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFWDProductCell : UITableViewCell
@property(nonatomic,strong)HFYDDetialRightDataModel *model;

- (void)doMessageSomething;
@end

NS_ASSUME_NONNULL_END
