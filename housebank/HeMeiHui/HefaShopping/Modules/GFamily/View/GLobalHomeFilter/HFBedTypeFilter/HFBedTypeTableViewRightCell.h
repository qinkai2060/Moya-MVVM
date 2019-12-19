//
//  HFBedTypeTableViewRightCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFilterBedTypeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFBedTypeTableViewRightCell : UITableViewCell
@property(nonatomic,strong)UILabel *titelb;
@property(nonatomic,strong)UIView *viewline;
@property(nonatomic,strong)UIImageView *selectGouImageView;
@property(nonatomic,strong)HFFilterBedTypeModel *bedModel;
- (void)doMessageSomething;
@end

NS_ASSUME_NONNULL_END
