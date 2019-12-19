//
//  YunDianNewRefundDetailSellerResultView.m
//  HeMeiHui
//
//  Created by 张磊 on 2019/10/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "YunDianNewRefundDetailSellerResultView.h"
#import "ReturnLabelHeight.h"
#import "YunDianNewRefundBuyerOrSellerRefundImagesMode.h"

@interface YunDianNewRefundDetailSellerResultView()
@property (nonatomic, assign) BOOL isCreateImg;
@end

@implementation YunDianNewRefundDetailSellerResultView

- (void) setupButtonWithArr:(NSArray *)array {
    if (array.count == 0) {
        return;
    }
    self.isCreateImg = YES;
    CGFloat btnW = (ScreenW - 75)/4;
    CGFloat btnH = btnW;
    for (int i = 0; i < array.count; i ++) {
        YunDianNewRefundBuyerOrSellerRefundImagesMode *model = (YunDianNewRefundBuyerOrSellerRefundImagesMode*)array[i];
        NSInteger row = i/4;
        NSInteger col = i%4;
        CGFloat btnX = 15 + (btnW + 15) * col;
        CGFloat btnY = 15 + (btnH + 15) * row;
        
        NSString *imgurl = [NSString stringWithFormat:@"%@",model.imagePath];
        UIImageView *img = [[UIImageView alloc] init];
        img.tag = 10000 + i;
        img.userInteractionEnabled = YES;
        [img sd_setImageWithURL:[imgurl get_Image] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
        [self addSubview:img];
        img.backgroundColor = [UIColor yellowColor];
        [img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(btnX);
            make.top.equalTo(self.sellerDetailLable.mas_bottom).offset(btnY);
            make.size.mas_equalTo(CGSizeMake(btnW, btnH));
        }];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapAction:)];
        [img addGestureRecognizer:tap];
    }
}
- (void)imgTapAction:(UITapGestureRecognizer *)tap{
    UIImageView *img = (UIImageView *)tap.view;
    NSInteger index = img.tag - 10000;
    if (index >= 0 && [self.delegate respondsToSelector:@selector(yunDianNewRefundDetailSellerResultViewDelegateClickImgIndex:)]) {
        [self.delegate yunDianNewRefundDetailSellerResultViewDelegateClickImgIndex:index
         ];
        
    }
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.line];
    
    [self addSubview:self.timeLable];
    [self.timeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.sellerResultLable];
    
    [self.sellerResultLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self.timeLable.mas_left).offset(-15);
        make.top.equalTo(self).offset(15);
        make.height.mas_equalTo(20);
    }];
    
    [self addSubview:self.sellerDetailLable];
    [self.sellerDetailLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.sellerResultLable);
        make.top.equalTo(self.sellerResultLable.mas_bottom).offset(10);
        make.right.equalTo(self.timeLable);
    }];
    
    
}
- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(15, 0, ScreenW - 30, 0.8)];
        _line.backgroundColor = HEXCOLOR(0xF5F5F5);
    }
    return _line;
}
- (UILabel *)sellerResultLable{
    if (!_sellerResultLable) {
        _sellerResultLable = [[UILabel alloc] init];
        _sellerResultLable.text = @"";
        _sellerResultLable.font = [UIFont boldSystemFontOfSize:13];
        _sellerResultLable.textColor = HEXCOLOR(0x333333);
        _sellerResultLable.numberOfLines = 1;
        _sellerResultLable.textAlignment = NSTextAlignmentLeft;
        
    }
    return _sellerResultLable;
}
- (UILabel *)timeLable{
    if (!_timeLable) {
        _timeLable = [[UILabel alloc] init];
        _timeLable.text = @"sssss";
        _timeLable.font = [UIFont systemFontOfSize:13];
        _timeLable.textColor = HEXCOLOR(0x333333);
        _timeLable.numberOfLines = 1;
        _timeLable.textAlignment = NSTextAlignmentRight;
        
    }
    return _timeLable;
}
- (UILabel *)sellerDetailLable{
    if (!_sellerDetailLable) {
        _sellerDetailLable = [[UILabel alloc] init];
        _sellerDetailLable.text =@"";
        _sellerDetailLable.font = [UIFont systemFontOfSize:13];
        _sellerDetailLable.textColor = HEXCOLOR(0x333333);
        _sellerDetailLable.numberOfLines = 0;
//        _sellerDetailLable.hidden = YES;
        _sellerDetailLable.textAlignment = NSTextAlignmentLeft;
        
    }
    return _sellerDetailLable;
}
- (void)setRefundDetailModel:(YunDianNewRefundDetailModel *)refundDetailModel{
    _refundDetailModel = refundDetailModel;
    if (([_refundDetailModel.autoRefund integerValue] == 1 && [_refundDetailModel.returnState integerValue]== 7)  || ([_refundDetailModel.autoRefund integerValue] == 1 && [_refundDetailModel.returnState integerValue]== 5) || ([_refundDetailModel.autoRefund integerValue] == 1 && [_refundDetailModel.returnState integerValue]== 6)) {
           //卖家超时 并且进入仲裁
        self.sellerDetailLable.hidden = YES;
        self.sellerResultLable.text = @"卖家超时未处理";
    }  else {
            //卖家拒绝退款
        self.sellerResultLable.text = @"卖家拒绝退款";
        self.sellerDetailLable.hidden = NO;
        if (_refundDetailModel.sellerRefundImages.count > 0 && !_isCreateImg) {
            [self setupButtonWithArr:_refundDetailModel.sellerRefundImages];

        }
    }
    self.timeLable.text = _refundDetailModel.updateDate;
    self.sellerDetailLable.text = CHECK_STRING(_refundDetailModel.reason);
    
}
+ (CGFloat)yunDianNewRefundDetailSellerResultViewReturnHeight:(YunDianNewRefundDetailModel *)refundDetailModel{
    CGFloat height = 0.f;
     if (([refundDetailModel.autoRefund integerValue] == 1 && [refundDetailModel.returnState integerValue]== 7)  || ([refundDetailModel.autoRefund integerValue] == 1 && [refundDetailModel.returnState integerValue]== 5) || ([refundDetailModel.autoRefund integerValue] == 1 && [refundDetailModel.returnState integerValue]== 6)) {
             //7卖家超时 仲裁退款  //5卖家超时 并且进入仲裁  //6卖家超时 仲裁拒绝
         height = 50;
         
      }  else  {
          //卖家拒绝退款
           CGFloat imgHeight = 0.f;
          if (refundDetailModel.sellerRefundImages.count > 0) {
              if (refundDetailModel.sellerRefundImages.count <= 4) {
                imgHeight =  (ScreenW - 75)/4 + 15;
              } else {
                imgHeight =  ((ScreenW - 75)/4 ) * 2 + 30;
              }
          }
              
          height = 45 + [ReturnLabelHeight getHeightByWidth:ScreenW - 30 title:CHECK_STRING(refundDetailModel.reason) font:[UIFont systemFontOfSize:13]] + imgHeight;
          
          if (!CHECK_STRING_ISNULL(refundDetailModel.reason)) {
              height += 15;
          }
          
      } 
    return height;
}
@end
