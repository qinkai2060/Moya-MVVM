//
//  HFRecommendSortCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/9.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFilterRecommendModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFRecommendSortCell : UITableViewCell
@property(nonatomic,strong)UILabel *titelb;
@property(nonatomic,strong)UIImageView *selectGouImageView;

@property(nonatomic,strong)HFFilterRecommendModel *model;
- (void)doMessageSomething;
@end

NS_ASSUME_NONNULL_END
