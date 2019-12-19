//
//  ManageOwnTableViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageOwnTableViewCell.h"
#import "ManageOwnModel.h"
#import "NSString+Person.h"
#import "HandleEventDefine.h"
#import "JudgeOrderType.h"
@interface ManageOwnTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIView  *downView;
@property (weak, nonatomic) IBOutlet UIView  *tuiView;
@property (nonatomic, strong) ManageOwnModel * itemModel;
@property (weak, nonatomic) IBOutlet UILabel *sharePointLabel;
@end
@implementation ManageOwnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.downView.layer.masksToBounds = YES;
    self.downView.layer.cornerRadius = 4;
    self.downView.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    self.downView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.downView.layer.borderWidth = 1;
    self.tuiView.layer.masksToBounds = YES;
    self.tuiView.layer.cornerRadius = 4;
    self.tuiView.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    self.tuiView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.tuiView.layer.borderWidth = 1;
    @weakify(self);
    UITapGestureRecognizer * downTap = [[UITapGestureRecognizer alloc]init];
    self.downView.userInteractionEnabled = YES;
    [self.downView addGestureRecognizer:downTap];
    [[downTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self rounterEventWithName:DownAwayShop userInfo:@{
                                                           @"microProductId":objectOrEmptyStr(self.itemModel.id)
                                                           }];
    }];
    
    UITapGestureRecognizer * shareTap = [[UITapGestureRecognizer alloc]init];
    self.tuiView.userInteractionEnabled = YES;
    [self.tuiView addGestureRecognizer:shareTap];
    [[shareTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self rounterEventWithName:ManageShare userInfo:@{
                                                          @"itemModel":objectOrEmptyStr(self.itemModel)
                                                          }];
    }];
}

- (void)customViewWithData:(id<JXModelProtocol>)data indexPath:(NSIndexPath *)path{
    self.itemModel = (ManageOwnModel *)data;
    [self.iconImageView sd_setImageWithURL:[self.itemModel.imgUrl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLabel.text = objectOrEmptyStr(self.itemModel.productName);

    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.itemModel.price floatValue]]]];
    self.countLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.itemModel.profit floatValue]]]];
    self.sharePointLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.itemModel.sharerProfitPrice floatValue]]]];
}

- (void)handleEvent:(void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))event {
   
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self rounterEventWithName:ManageShopDetail userInfo:@{
                                                           @"productID":objectOrEmptyStr(self.itemModel.productId)
                                                           }];

}

+ (id)loadFromXib {
    ManageOwnTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                          owner:self
                                                                        options:nil][0];
    return cell;
}

- (ManageOwnModel *)itemModel {
    if (!_itemModel) {
        _itemModel = [[ManageOwnModel alloc]init];
    }
    return _itemModel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
