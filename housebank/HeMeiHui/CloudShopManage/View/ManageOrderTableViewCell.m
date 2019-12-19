//
//  ManageOrderTableViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "ManageOrderTableViewCell.h"
#import "HandleEventDefine.h"
#import "JudgeOrderType.h"
#import "ManageOrderModel.h"
@interface ManageOrderTableViewCell ()
@property (nonatomic, strong) ManageOrderListModel * itemModel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (nonatomic, assign) NSInteger indexSection;

@end
@implementation ManageOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)customViewWithData:(id<JXModelProtocol>)data indexPath:(NSIndexPath *)path{
    self.itemModel = (ManageOrderListModel *)data;
    self.indexSection = path.section;
     [self.iconImageView sd_setImageWithURL:[self.itemModel.imagePath get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
     self.priceLabel.text = [NSString stringWithFormat:@"￥%@",[JudgeOrderType positiveFormat: [NSString stringWithFormat:@"%.2f",[self.itemModel.salePrice floatValue]]]];
    self.titleLabel.text  =objectOrEmptyStr(self.itemModel.productName);
    if (self.itemModel.specificationsName && self.itemModel.specificationsName) {
        self.colorLabel.text = [NSString stringWithFormat:@"%@: %@",self.itemModel.specificationsName,self.itemModel.specificationsName];
    }
}

- (void)handleEvent:(void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self rounterEventWithName:ManageOrder userInfo:@{
                                                      @"isDistribution":objectOrEmptyStr(self.itemModel.isDistribution),
                                                      @"orderId":objectOrEmptyStr(self.itemModel.orderId),
                                                      @"index":@(self.indexSection)
                                                      }];
}

+ (id)loadFromXib {
    ManageOrderTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                                 owner:self
                                                               options:nil][0];
    return cell;
}

#pragma mark -- lazy load
- (ManageOrderListModel *)itemModel {
    if (!_itemModel) {
        _itemModel = [[ManageOrderListModel alloc]init];
    }
    return _itemModel;
}
@end
