//
//  ManageShopViewCellTableViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageShopViewCellTableViewCell.h"
#import "ManageSelectShopModel.h"
#import "NSString+Person.h"
#import "HandleEventDefine.h"
#import "JudgeOrderType.h"
@interface ManageShopViewCellTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *getNumLabel;
@property (weak, nonatomic) IBOutlet UIView *addView;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UIImageView *addImage;
@property (weak, nonatomic) IBOutlet UILabel *sharePoint;
@property (nonatomic, strong) ManageSelectShopModel * itemModel;
@end
@implementation ManageShopViewCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addLabel.layer.cornerRadius = 4;
    self.addLabel.layer.masksToBounds = YES;
    self.addView.layer.masksToBounds = YES;
    self.addView.layer.cornerRadius = 4;
    self.addView.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
    self.addView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.addView.layer.borderWidth = 1;
    self.addView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [self.addView addGestureRecognizer:tap];
    @weakify(self);
    [[tap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self.delegate canActionTheAddToWeiShopTuple:[RACTuple tupleWithObjects:objectOrEmptyStr(self.itemModel.productId), nil] error:^(BOOL isSuccess) {
             @strongify(self);
            if (isSuccess == YES) {
                [self changeAddViewWithBool:YES];
            }
        }];
    }];
}

- (void)changeAddViewWithBool:(BOOL)show {
    if (show == YES) {
        self.addLabel.text = @"已添加";
        self.addView.backgroundColor = [UIColor colorWithHexString:@"#F5F5F5"];
        self.addImage.hidden = YES;
        self.addView.userInteractionEnabled = NO;
    }else {
        self.addLabel.text = @"加入微店";
        self.addView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.addImage.hidden = NO;
        self.addView.userInteractionEnabled = YES;
    }
}

- (void)customViewWithData:(id<JXModelProtocol>)data indexPath:(NSIndexPath *)path{
    self.itemModel = (ManageSelectShopModel *)data;
    [self changeAddViewWithBool:NO];
    [self.iconImage sd_setImageWithURL:[self.itemModel.imgUrl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    self.titleLabel.text = objectOrEmptyStr(self.itemModel.productName);
     self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.itemModel.price floatValue]]]];
    self.getNumLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.itemModel.profit floatValue]]]];
     self.sharePoint.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.itemModel.sharerProfitPrice floatValue]]]];
}

- (void)handleEvent:(void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self rounterEventWithName:ManageShopDetail userInfo:@{
                            @"productID":objectOrEmptyStr(self.itemModel.productId)
                                                           }];
}

+ (id)loadFromXib {
    ManageShopViewCellTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                  owner:self
                                                                options:nil][0];
    return cell;
}

- (ManageSelectShopModel *)itemModel {
    if (!_itemModel) {
        _itemModel = [[ManageSelectShopModel alloc]init];
    }
    return _itemModel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
