//
//  HFBedTypeTableViewLeftCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFilterBedTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFBedTypeTableViewLeftCell : UITableViewCell
@property(nonatomic,strong)UILabel *titelb;
@property(nonatomic,strong)HFFilterBedTypeModel *bedModel;
- (void)doMessageSomething;
@end

NS_ASSUME_NONNULL_END
