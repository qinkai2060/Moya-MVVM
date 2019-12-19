//
//  CloudManageViewCell.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudManageViewCell.h"
#import "HandleEventDefine.h"
#import "CloudManageModel.h"
#import "YunDianShopListModel.h"
#import "YunDianOrderViewController.h"
@interface CloudManageViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;       // 审核被拒状态
@property (weak, nonatomic) IBOutlet UIImageView *shopImage;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;   // 地点
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;        // 店铺二维码
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;   // 店铺二维码图片
@property (weak, nonatomic) IBOutlet UIButton *AfterBtn;       // 推广
@property (weak, nonatomic) IBOutlet UIImageView *afterImage;  // 推广图片
@property (weak, nonatomic) IBOutlet UIButton *orderBtn;       // 订单
@property (weak, nonatomic) IBOutlet UIImageView *orderImage;  // 订单图片
@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (nonatomic, strong) CloudManageItemModel * itemModel;

@end
@implementation CloudManageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backGroundView.userInteractionEnabled = YES;
    self.backGroundView.layer.cornerRadius = 5;
    self.orderImage.userInteractionEnabled = YES;
    self.afterImage.userInteractionEnabled = YES;
    self.codeImage.userInteractionEnabled = YES;
    
    @weakify(self);
    UITapGestureRecognizer * codeTap = [[UITapGestureRecognizer alloc]init];
    [self.codeImage addGestureRecognizer:codeTap];
    [[codeTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self rounterEventWithName:ClodeCode userInfo:@{@"model":objectOrEmptyStr(self.itemModel)}];
    }];
    [[self.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self rounterEventWithName:ClodeCode userInfo:@{@"model":objectOrEmptyStr(self.itemModel)}];
    }];
    
    UITapGestureRecognizer * afterTap = [[UITapGestureRecognizer alloc]init];
    [self.afterImage addGestureRecognizer:afterTap];
    [[afterTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self rounterEventWithName:Cloudshare userInfo:@{@"model":objectOrEmptyStr(self.itemModel)}];
    }];
    [[self.AfterBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self rounterEventWithName:Cloudshare userInfo:@{@"model":objectOrEmptyStr(self.itemModel)}];
    }];
    
    UITapGestureRecognizer * orderTap = [[UITapGestureRecognizer alloc]init];
    [self.orderImage addGestureRecognizer:orderTap];
    [[orderTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        [self pushOrder];
    }];
    [[self.orderBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self pushOrder];
    }];
}

- (void)pushOrder {
    YunDianShopListModel * shopModel = [[YunDianShopListModel alloc]init];
    shopModel.shopsId = self.itemModel.shopId;
    shopModel.shopsName = self.itemModel.shopName;
    shopModel.shopsType = self.itemModel.shopType;
    YunDianOrderViewController * orderVC = [[YunDianOrderViewController alloc]init];
    orderVC.shopListModel = shopModel;
    [[UIViewController visibleViewController].navigationController pushViewController:orderVC animated:YES];
}

- (void)customViewWithData:(id<JXModelProtocol>)data indexPath:(NSIndexPath *)path{
    CloudManageModel * model = (CloudManageModel *)data;
    self.itemModel = model.dataSource.firstObject;
    self.shopNameLabel.text = objectOrEmptyStr(self.itemModel.shopName);
    self.locationLabel.text = objectOrEmptyStr(self.itemModel.address);

    if (self.itemModel.createDate.length > 10) {
        self.timeLabel.text = [NSString stringWithFormat:@"最后编辑: %@",[objectOrEmptyStr((self.itemModel.updateTime?self.itemModel.updateTime:self.itemModel.createDate)) substringToIndex:10] ];
    }
    
    // 状态 0 待处理 1审核中 2审核拒绝 3 审核通过
    if ([self.itemModel.state isEqualToString:@"0"]) {
        self.infoLabel.text = @"待处理";
    }else if ([self.itemModel.state isEqualToString:@"1"]) {
        self.infoLabel.text = @"审核中";
    }else if ([self.itemModel.state isEqualToString:@"2"]) {
        self.infoLabel.text = @"审核拒绝";
    }else if ([self.itemModel.state isEqualToString:@"3"] || [self.itemModel.state isEqualToString:@"5"]) {
        self.infoLabel.text = @"";
    }
    
    
    BOOL hidden;
    if ([self.itemModel.state isEqualToString:@"3"]) {
        hidden = NO;
    }else {
        hidden = YES;
    }
    [self hiddenInfoTag:hidden];
    
    if([self.itemModel.shopType isEqualToString:@"2"]) {
        self.titleLabel.text = @"云店-OTO";
        [self.shopImage sd_setImageWithURL:[self.itemModel.shopImg  get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    }else if ([self.itemModel.shopType isEqualToString:@"3"]){
        self.titleLabel.text = @"云店-微店";
        [self.shopImage sd_setImageWithURL:[self.itemModel.logoImg  get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    }
    
}

- (void)hiddenInfoTag:(BOOL)hidden {
    self.codeBtn.hidden = hidden;
    self.codeImage.hidden = hidden;
    self.AfterBtn.hidden = hidden;
    self.afterImage.hidden = hidden;
    self.orderBtn.hidden = hidden;
    self.orderImage.hidden = hidden;
}

- (void)handleEvent:(void (^)(NSDictionary * _Nonnull, NSString * _Nonnull))event {
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self rounterEventWithName:CloudePushManage userInfo:@{@"shopType":self.itemModel.shopType,
                                                           @"state":self.itemModel.state,
                                                           @"shopID":objectOrEmptyStr(self.itemModel.shopId),
                                                           @"auditRemark":objectOrEmptyStr(self.itemModel.auditRemark),
                                                           @"localAddress":objectOrEmptyStr(self.itemModel.localAddress),
                                                           @"itemModel":objectOrEmptyStr(self.itemModel)
                                                           }];
}

+ (id)loadFromXib {
    CloudManageViewCell *cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                               owner:self
                                                             options:nil][0];
    return cell;
}

- (CloudManageItemModel *)itemModel {
    if (!_itemModel) {
        _itemModel = [[CloudManageItemModel alloc]init];
    }
    return _itemModel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
