//
//  HFYDCarProductCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFYDDetialDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFYDCarProductCell : UITableViewCell
@property(nonatomic,strong)HFYDCarProductModel  *carmodel;
@property(nonatomic,strong)UIButton *plusBtn;
@property(nonatomic,strong)UILabel *countLb;
@property(nonatomic,strong)UIButton *minBtn;
@property(nonatomic,strong)UILabel *priceLb;
@property(nonatomic,strong)UILabel *nameLb;
@property(nonatomic,strong)UILabel *specialsLb;
- (void)domessageDataSomthing;
@end

NS_ASSUME_NONNULL_END
