//
//  HFCountryCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFCountryCodeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFCountryCell : UITableViewCell
@property(nonatomic,strong)HFCountryCodeModel *model;
- (void)doMessagesomthing;
@end

NS_ASSUME_NONNULL_END
