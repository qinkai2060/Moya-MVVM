//
//  YunDianRefundDetailReasonView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianRefundDetailReasonView.h"
@implementation YunDianRefundDetailReasonView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    UILabel *refundReason = [[UILabel alloc] init];
    refundReason.text = @"退款原因";
    refundReason.font = [UIFont boldSystemFontOfSize:12];
    refundReason.textColor = HEXCOLOR(0x333333);
    refundReason.numberOfLines = 1;
    refundReason.textAlignment = NSTextAlignmentLeft;
    [self addSubview:refundReason];
    [refundReason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.refundReasonLabel];
    [self.refundReasonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(refundReason.mas_bottom).offset(5);
        make.left.equalTo(refundReason);
        make.right.equalTo(self).offset(-15);
    }];
    
    
}
- (void)setArrImg:(NSArray *)arrImg{
    _arrImg = arrImg;
    [self setupButtonWithArr:_arrImg];
  
}
- (void)setRefundDetailModel:(YunDianRefundDetailModel *)refundDetailModel{
    _refundDetailModel = refundDetailModel;
     self.refundReasonLabel.text = CHECK_STRING(_refundDetailModel.remark);
}
- (void) setupButtonWithArr:(NSArray *)array {
    if (array.count == 0) {
        return;
    }
    CGFloat btnW = (ScreenW - 60)/3;
    CGFloat btnH = btnW;
    for (int i = 0; i < array.count; i ++) {
        NSInteger row = i/3;
        NSInteger col = i%3;
        CGFloat btnX = 15 + (btnW + 15) * col;
        CGFloat btnY = 15 + (btnH + 15) * row;
        
        NSString *imgurl = [NSString stringWithFormat:@"%@",array[i]];
        UIImageView *img = [[UIImageView alloc] init];
        img.tag = 9000 + i;
        img.userInteractionEnabled = YES;
        [img sd_setImageWithURL:[NSURL URLWithString:imgurl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
        [self addSubview:img];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(btnX);
            make.top.equalTo(self.refundReasonLabel.mas_bottom).offset(btnY);
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapAction:)];
        [img addGestureRecognizer:tap];
    }
}
- (void)imgTapAction:(UITapGestureRecognizer *)tap{
    UIImageView *img = (UIImageView *)tap.view;
    if ([self.delegate respondsToSelector:@selector(yunDianRefundDetailReasonViewDelegateClickImgIndex:)]) {
        [self.delegate yunDianRefundDetailReasonViewDelegateClickImgIndex:(img.tag - 9000)];
    }
}
- (UILabel *)refundReasonLabel{
    if (!_refundReasonLabel) {
        _refundReasonLabel = [[UILabel alloc] init];
        _refundReasonLabel.font = [UIFont systemFontOfSize:12];
        _refundReasonLabel.text = @"";
        _refundReasonLabel.textColor = HEXCOLOR(0x333333);
        _refundReasonLabel.numberOfLines = 0;
        _refundReasonLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _refundReasonLabel;
}

@end
