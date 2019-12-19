//
//  HFAPPRariseCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFYDDetialDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFAPPRariseCell : UITableViewCell
@property(nonatomic,strong)HFYDDetialRariseDataModel *model;
- (void)doMessageSomthing ;
@end

NS_ASSUME_NONNULL_END
