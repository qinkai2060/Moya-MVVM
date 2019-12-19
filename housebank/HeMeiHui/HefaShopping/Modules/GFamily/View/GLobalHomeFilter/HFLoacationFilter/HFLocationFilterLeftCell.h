//
//  HFLocationFilterLeftCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFilterLocationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFLocationFilterLeftCell : UITableViewCell
@property(nonatomic,strong)UILabel *titelb;
@property(nonatomic,strong)  HFFilterLocationModel *model;
- (void)doMessageSomething ;
@end

NS_ASSUME_NONNULL_END
