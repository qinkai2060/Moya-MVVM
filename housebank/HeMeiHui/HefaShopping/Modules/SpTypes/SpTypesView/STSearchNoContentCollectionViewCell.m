//
//  STSearchNoContentCollectionViewCell.m
//  housebank
//
//  Created by liqianhong on 2018/10/30.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "STSearchNoContentCollectionViewCell.h"

@interface STSearchNoContentCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *subTitleLab;
@property (nonatomic, strong) UILabel *pinTuanLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *yuanPriceLab;
@property (nonatomic, strong) UILabel *lineLab;

@end

@implementation STSearchNoContentCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (void)createView{
    //
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.width)];
    self.iconImageView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 5.0;
    [self addSubview:self.iconImageView];
    
    //
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.frame.origin.x, CGRectGetMaxY(self.iconImageView.frame) + 5, self.iconImageView.frame.size.width, 40)];
    self.titleLab.font = [UIFont systemFontOfSize:15.0];
    self.titleLab.textColor = RGBACOLOR(51, 51, 51, 1);
    self.titleLab.numberOfLines = 0;
    [self addSubview:self.titleLab];
    
    //
    self.subTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLab.frame.origin.x, CGRectGetMaxY(self.titleLab.frame), self.titleLab.frame.size.width, 20)];
    self.subTitleLab.font = [UIFont systemFontOfSize:12.0];
    self.subTitleLab.textColor = RGBACOLOR(153, 153, 153, 1);
    [self addSubview:self.subTitleLab];
    
    //
    self.pinTuanLab = [[UILabel alloc] initWithFrame:CGRectMake(self.subTitleLab.frame.origin.x, CGRectGetMaxY(self.subTitleLab.frame) + 5, 40, 20)];
    self.pinTuanLab.font = [UIFont systemFontOfSize:11.0];
    self.pinTuanLab.textColor = RGBACOLOR(243, 52, 74, 1);
    [self addSubview:self.pinTuanLab];
    
    //
    self.priceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.pinTuanLab.frame) , self.pinTuanLab.frame.origin.y, 60, 20)];
    self.priceLab.font = [UIFont systemFontOfSize:12.0];
    self.priceLab.textColor = RGBACOLOR(243, 52, 74, 1);
    [self addSubview:self.priceLab];
    
    //
    self.yuanPriceLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLab.frame), self.priceLab.frame.origin.y, 40, 20)];
    self.yuanPriceLab.font = [UIFont systemFontOfSize:10.0];
    self.yuanPriceLab.textColor = RGBACOLOR(153, 153, 153, 1);
    [self addSubview:self.yuanPriceLab];
    
    //
    self.lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.yuanPriceLab.frame.size.width, 1)];
    self.lineLab.backgroundColor = RGBACOLOR(153, 153, 153, 1);
    [self.yuanPriceLab addSubview:self.lineLab];
}
- (void)refreshViewWithModel:(id)model{
    self.titleLab.text = @"浦发银行 投资足金金条 30G";
    self.subTitleLab.text = @"黄金金砖金块/银行金条30G";
    
    NSString *pinTuanStr = @"拼团价";
    self.pinTuanLab.text =pinTuanStr;
    CGFloat pW = [MyUtil getWidthWithFont:[UIFont systemFontOfSize:11.0] height:20 text:pinTuanStr];
    CGRect pinTuanRect = self.pinTuanLab.frame;
    pinTuanRect.size.width = pW + 5;
    self.pinTuanLab.frame = pinTuanRect;
    
    NSString *str =@"¥0.90";
    NSRange range = [str rangeOfString:@"."];//匹配得到的下标
    self.priceLab.attributedText = [MyUtil getAttributedWithString:str Color:RGBACOLOR(243, 52, 74, 1) font:[UIFont systemFontOfSize:14.0] range:NSMakeRange(1, range.location)];
    
    CGFloat priceW = [MyUtil getWidthWithFont:[UIFont systemFontOfSize:14.0] height:20 text:str];
    CGRect rect = self.priceLab.frame;
    rect.origin.x = CGRectGetMaxX(self.pinTuanLab.frame);
    rect.size.width = priceW + 5;
    self.priceLab.frame = rect;
    
    NSString *yStr = @"¥8888";
    self.yuanPriceLab.text = yStr;
    CGFloat yW = [MyUtil getWidthWithFont:[UIFont systemFontOfSize:10.0] height:20 text:yStr];
    CGRect yRect = self.yuanPriceLab.frame;
    yRect.size.width = yW + 2;
    yRect.origin.x = CGRectGetMaxX(self.priceLab.frame) + 2;
    self.yuanPriceLab.frame = yRect;
    
    self.lineLab.frame = CGRectMake(0, 10, self.yuanPriceLab.frame.size.width, 1);
}

@end
