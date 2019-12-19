//
//  ManageSortTableViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageSortTableViewCell.h"
#import "HandleEventDefine.h"
#import "NSString+Person.h"
#import "UILabel+Vertical.h"
#import "JudgeOrderType.h"
@interface ManageSortTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;

@end 
@implementation ManageSortTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization cod
    @weakify(self);
    [[self.topBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self rounterEventWithName:TopProduct userInfo:@{
                                                @"microProductId":objectOrEmptyStr(self.model.id)
                                                         }];
    }];
}

- (void)setModel:(ManageOwnModel *)model {
    _model = model;
    [self.iconImageView sd_setImageWithURL:[self.model.imgUrl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLabel.text = objectOrEmptyStr(self.model.productName);
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.model.price floatValue]]]];
    self.countLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.model.profit floatValue]]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
