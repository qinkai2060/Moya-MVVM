//
//  ManageDownTableViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageDownTableViewCell.h"
#import "HandleEventDefine.h"
#import "NSString+Person.h"
#import "JudgeOrderType.h"
@interface ManageDownTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, assign) BOOL select;

@end
@implementation ManageDownTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.select = NO;
    @weakify(self);
    [[self.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.select = !self.select;
        [self changeBtnSelect:self.select];
        [self rounterEventWithName:DownSelectShop userInfo:@{
                                                             @"microProductId":objectOrEmptyStr(self.model.id)
                                                             }];
    }];
}

- (void)setModel:(ManageOwnModel *)model {
    _model = model;
    self.select = model.isSelect;
    [self changeBtnSelect:model.isSelect];
    [self.iconImageView sd_setImageWithURL:[self.model.imgUrl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLabel.text = objectOrEmptyStr(self.model.productName);
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.model.price floatValue]]]];
    self.countLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.model.profit floatValue]]]];
}

- (void)changeBtnSelect:(BOOL)select {
    if (select) {
        [self.selectBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }else {
        [self.selectBtn setImage:[UIImage imageNamed:@"cloude_NoSelect"] forState:UIControlStateNormal];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
