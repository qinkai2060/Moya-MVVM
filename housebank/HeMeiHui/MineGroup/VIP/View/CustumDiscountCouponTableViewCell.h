//
//  CustumDiscountCouponTableViewCell.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscountCouponModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^CustumDiscountCouponTableViewCellGetBtnActionBlock)(NSInteger tag);

@interface CustumDiscountCouponTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *conditionLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIButton *getBtn;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIImageView *imgBg;
@property (nonatomic, strong) DiscountCouponModel *couponModel;
@property (nonatomic, copy) CustumDiscountCouponTableViewCellGetBtnActionBlock getBtnActionBlock;
@end

NS_ASSUME_NONNULL_END
