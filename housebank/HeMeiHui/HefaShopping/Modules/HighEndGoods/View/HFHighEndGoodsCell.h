//
//  HFHighEndGoodsCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HFDataModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^didSelectBlock)(HFDataModel*);
@interface HFHighEndGoodsCell : UITableViewCell
@property (nonatomic,strong) UIImageView *goodsImageV;
@property (nonatomic,strong) UILabel *goodsTitleLb;
@property (nonatomic,strong) UILabel *goodsDescriptionLb;
@property (nonatomic,strong) UILabel *goodsPriceLb;

@property (nonatomic,strong) UIButton *plusBtn;
@property (nonatomic,strong) CAGradientLayer *gradientLayer;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UILabel *tagLb;
@property (nonatomic,strong) UILabel *typeLb;
@property (nonatomic,strong) HFDataModel *dataModel;
@property (nonatomic,copy) didSelectBlock didSelect;
- (void)dosomethingMessage;
//- (void)dosomethingMessage2;
@end

NS_ASSUME_NONNULL_END
