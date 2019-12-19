//
//  ManageOwnEndTableViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageOwnEndTableViewCell.h"
#import "ManageSellEndModel.h"
#import "HandleEventDefine.h"
#import "JudgeOrderType.h"
@interface ManageOwnEndTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView *upView;
@property (weak, nonatomic) IBOutlet UIView *maskView;
@property (nonatomic, strong) ManageSellEndModel * itemModel;
@end

@implementation ManageOwnEndTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.upView.layer.masksToBounds = YES;
    self.upView.layer.cornerRadius = 4;
    self.upView.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    self.upView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.upView.layer.borderWidth = 1;
    self.maskView.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.5f];
    UILabel * label = [UILabel new];
    label.text = @"已下架";
    label.font = kFONT(13);
    label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    label.textAlignment = NSTextAlignmentCenter;
    [self.maskView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.maskView);
        make.width.equalTo(self.maskView);
        make.height.equalTo(@18);
    }];
    
    self.upView.userInteractionEnabled = YES;
    UITapGestureRecognizer * upTap = [[UITapGestureRecognizer alloc]init];
    [self.upView addGestureRecognizer:upTap];
    @weakify(self);
    [[upTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self rounterEventWithName:PutAwayShop userInfo:@{
                                                          @"microProductId":objectOrEmptyStr(self.itemModel.id)
                                                          }];
    }];
}

- (void)customViewWithData:(id<JXModelProtocol>)data indexPath:(NSIndexPath *)path{
    self.itemModel = (ManageSellEndModel *)data;
    if([self.itemModel.imgUrl get_Image]) {
        [self.iconImageView sd_setImageWithURL:[self.itemModel.imgUrl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    }else {
        self.iconImageView.image = [UIImage imageNamed:@"SpTypes_default_image"];
    }
    self.titleLabel.text = objectOrEmptyStr(self.itemModel.productName);
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.itemModel.price floatValue]]]];
    self.countLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.itemModel.profit floatValue]]]];
}

- (void)handleEvent:(void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self rounterEventWithName:ManageShopDetail userInfo:@{
                                                           @"productID":objectOrEmptyStr(self.itemModel.productId)
                                                           }];

}

+ (id)loadFromXib {
    ManageOwnEndTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                 owner:self
                                                               options:nil][0];
    return cell;
}

- (ManageSellEndModel *)itemModel {
    if (!_itemModel) {
        _itemModel = [[ManageSellEndModel alloc]init];
    }
    return _itemModel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
