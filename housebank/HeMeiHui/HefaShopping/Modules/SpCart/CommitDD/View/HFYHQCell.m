//
//  HFYHQCell.m
//  HeMeiHui
//
//  Created by usermac on 2019/6/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFYHQCell.h"
#import "HFTextCovertImage.h"
@interface HFYHQCell()
@property (nonatomic,strong)UILabel *priceLb;
@property (nonatomic,strong)UILabel *titleLb;
@property (nonatomic,strong)UILabel *dateLb;
@property (nonatomic,strong)UILabel *disableLb;
@property (nonatomic,strong)UILabel *describeLb;
@property (nonatomic,strong)UIImageView *bgImageView;
@property (nonatomic,strong)UIButton *selectBtn;
@end
@implementation HFYHQCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.bgImageView];
        [self.contentView addSubview:self.disableLb];
        [self.contentView addSubview:self.priceLb];
        [self.contentView addSubview:self.titleLb];
        [self.contentView addSubview:self.describeLb];
        [self.contentView addSubview:self.dateLb];
        [self.contentView addSubview:self.selectBtn];
        [[self.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            UIButton *btn = x;
            btn.selected = !btn.selected;
            if ([self.delegate respondsToSelector:@selector(yhqCell:model:)]) {
                [self.delegate yhqCell:self model:self.model];
            }
            
        }];
    }
    return self;
}
- (void)domessageSomething {
    self.bgImageView.frame = CGRectMake(15, 15, ScreenW-30, 90);
    if(self.model.pastDue){
        self.disableLb.hidden = NO;
        self.selectBtn.hidden = YES;
    }else {
        self.disableLb.hidden = YES;
        self.selectBtn.hidden = NO;
    }
    self.disableLb.text = @"不可用";
    self.titleLb.text = self.model.title;
    self.dateLb.text = [NSString stringWithFormat:@"%@-%@",self.model.startTime,self.model.endTime];
    self.priceLb.attributedText = [HFTextCovertImage exchangeTextStyle:[NSString stringWithFormat:@"¥%ld",self.model.discountMoney] twoText:@""];
     self.describeLb.text = self.model.describe;

    self.disableLb.frame = CGRectMake(self. bgImageView.right-25-48, 25+15, 48, 20);
    self.disableLb.centerY = self.bgImageView.centerY;
    self.selectBtn.frame = CGRectMake(self. bgImageView.right-23-44, 23+15, 44, 44);
    self.selectBtn.centerY = self.bgImageView.centerY;
    self.selectBtn.selected = self.model.selected;
    CGFloat left = 0;
    if (self.model.pastDue) {
        left = self. bgImageView.right-25-48-15-self.priceLb.right-15-10-44-23;
    }else {
        left = self. bgImageView.right-23-44-15-self.priceLb.right-15-10-44-23;
    }
    CGSize titleSize = [HFUntilTool boundWithStr:self.titleLb.text blodfont:14 maxSize:CGSizeMake(220, 40)];
    CGSize describeLbSize = [HFUntilTool boundWithStr:self.describeLb.text blodfont:14 maxSize:CGSizeMake(self.selectBtn.left-15-self.priceLb.right-15-10-44-23, 40)];
    CGSize dateSize = [self.dateLb sizeThatFits:CGSizeMake(208, 20)];
    CGSize priceSize = [self.priceLb sizeThatFits:CGSizeMake(208, 20)];
    self.priceLb.frame = CGRectMake(self.bgImageView.left+15, self.bgImageView.top+20, priceSize.width, 24);
    self.titleLb.frame = CGRectMake(self.priceLb.right+20, self.bgImageView.top+15, titleSize.width, titleSize.height);
    self.describeLb.frame = CGRectMake(self.priceLb.right+20, self.titleLb.bottom+2, describeLbSize.width, 16);
    self.dateLb.frame = CGRectMake(self.priceLb.left, self.describeLb.bottom+5, dateSize.width, 16);

}
- (UILabel *)titleLb {
    if (!_titleLb) {
        _titleLb = [HFUIkit textColor:@"333333" blodfont:14 numberOfLines:2];
    }
    return _titleLb;
}
- (UILabel *)dateLb {
    if (!_dateLb) {
        _dateLb = [HFUIkit textColor:@"666666" font:12 numberOfLines:1];
    }
    return _dateLb;
}
- (UILabel *) describeLb{
    if (!_describeLb) {
        _describeLb = [HFUIkit textColor:@"666666" font:12 numberOfLines:1];
    }
    return _describeLb;
}
- (UILabel *)priceLb {
    if (!_priceLb) {
        _priceLb = [[UILabel alloc] init];
    }
    return _priceLb;
}
- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yhq_bg"]];
        
    }
    return _bgImageView;
}
- (UILabel *)disableLb {
    if (!_disableLb) {
        _disableLb = [HFUIkit textColor:@"999999" font:14 numberOfLines:1];
    }
    return _disableLb;
}
- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_selectBtn setImage:[UIImage imageNamed:@"car_group"] forState:UIControlStateNormal];
        [_selectBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
        [_selectBtn setImage:[UIImage imageNamed:@"car_disable_icon"] forState:UIControlStateDisabled];
//        [_selectBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
        //        _selectBtn.enabled = NO;
        
    }
    return _selectBtn;
}
@end
