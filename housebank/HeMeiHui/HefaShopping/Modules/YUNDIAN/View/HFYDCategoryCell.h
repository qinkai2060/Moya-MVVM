//
//  HFYDCategoryCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFYDDetialDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFYDCategoryCell : UITableViewCell
@property(nonatomic,strong)HFYDDetialLeftDataModel *model;
@property(nonatomic,strong)UILabel *saleCountLb;
@property(nonatomic,strong)UILabel *titleLb;
- (void)doMessageSomthing;
@end

NS_ASSUME_NONNULL_END
