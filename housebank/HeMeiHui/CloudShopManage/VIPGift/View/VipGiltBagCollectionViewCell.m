//
//  VipGiltBagCollectionViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/7/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGiltBagCollectionViewCell.h"
#import "JudgeOrderType.h"
@interface VipGiltBagCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIView *BgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation VipGiltBagCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor colorWithHexString:@"100700"];
    self.BgView.layer.masksToBounds = YES;
    self.BgView.layer.cornerRadius = 5;
    self.BgView.layer.borderWidth = 1;
    self.BgView.layer.borderColor = [UIColor colorWithHexString:@"#FFDE86"].CGColor;
    self.iconImageView.image = [UIImage imageNamed:@"VipGift_1"];
    self.headImageView.backgroundColor = [UIColor whiteColor];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setUpShopModel:(VipGiftShopModel *)item withType:(NSString *)type {
    _itemModel = item;
    [self.headImageView sd_setImageWithURL:[self.itemModel.imageUrl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.typeLabel.text = objectOrEmptyStr(type);
    self.contentLabel.text = objectOrEmptyStr(self.itemModel.productName);
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.itemModel.cashPrice floatValue]]]];
}

@end
