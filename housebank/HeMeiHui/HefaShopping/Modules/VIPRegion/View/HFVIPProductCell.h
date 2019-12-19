//
//  HFVIPProductCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFVIPModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFVIPProductCell : UITableViewCell
@property(nonatomic,strong)UIImageView *productImagV;
@property(nonatomic,strong)UILabel *titleLb;
@property(nonatomic,strong)UILabel *priceLb;
@property(nonatomic,strong)UILabel *saleLb;// 销量
@property(nonatomic,strong)UILabel *stockLb;
@property(nonatomic,strong)CALayer *lineLayer;
@property(nonatomic,strong)HFVIPModel *model;

- (void)doSommthingData;
@end

NS_ASSUME_NONNULL_END
