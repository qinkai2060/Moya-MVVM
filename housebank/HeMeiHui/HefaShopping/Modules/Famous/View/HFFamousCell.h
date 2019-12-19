//
//  HFFamousCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFFamousGoodsModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^didSelectFamousBlock)(HFFamousGoodsModel*);
@interface HFFamousCell : UITableViewCell
@property (nonatomic,strong) UIImageView *goodsImageV;
@property (nonatomic,strong) UILabel *goodsTitleLb;
@property (nonatomic,strong) UILabel *goodsDescriptionLb;
@property (nonatomic,strong) UILabel *goodsPriceLb;

@property (nonatomic,strong) UIButton *plusBtn;
@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *tagLb;
@property (nonatomic,strong) UILabel *typeLb;
@property (nonatomic,strong) HFFamousGoodsModel *dataModel;
@property (nonatomic,copy) didSelectFamousBlock didSelect;
- (void)dosomethingMessage;
@end

NS_ASSUME_NONNULL_END
