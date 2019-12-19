//
//  HFSearchKeyCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFHistoryModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFSearchKeyCell : UITableViewCell
@property(nonatomic,strong)HFHistoryModel *model;
@property(nonatomic,strong)UILabel *label;
- (void)doMessgaeSomthing;
@end

NS_ASSUME_NONNULL_END
