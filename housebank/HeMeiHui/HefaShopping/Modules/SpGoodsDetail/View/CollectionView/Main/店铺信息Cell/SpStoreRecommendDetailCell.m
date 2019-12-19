//
//  SpStoreRecommendDetailCell.m
//  housebank
//
//  Created by zhuchaoji on 2018/12/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpStoreRecommendDetailCell.h"

@implementation SpStoreRecommendDetailCell
#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    _goodsImageView = [[UIImageView alloc] init];
    _goodsImageView.backgroundColor=HEXCOLOR(0xF7F7F7);
    _goodsImageView.layer.masksToBounds = YES;
    _goodsImageView.layer.cornerRadius = 4;
    _goodsImageView.contentMode = UIViewContentModeScaleAspectFit;
    _goodsImageView.userInteractionEnabled = YES;
    _goodsImageView.image=[UIImage imageNamed:@"icon_image"];
    [self addSubview:_goodsImageView];
    
    _goodsName = [[UILabel alloc] init];
    _goodsName.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular] ;
    _goodsName.textColor=HEXCOLOR(0x666666);
    _goodsName.text=@"百变魔方盒眼测试数据";
    _goodsName.textAlignment=NSTextAlignmentCenter;
    [self addSubview:_goodsName];
    NSString *text = @"¥153.90";
    NSString *floStr;NSString *intStr;
    NSString *text2 = @"¥198.5";
    if ([text containsString:@"."]) {
        NSRange range = [text rangeOfString:@"."];
        floStr = [text substringFromIndex:range.location];
        intStr = [text substringToIndex:range.location];
    }
    //    商品现价
    _currentPriceLabel = [UILabel lableFrame:CGRectZero title:text backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:10] textColor:HEXCOLOR(0xF3344A)];
     _currentPriceLabel.textAlignment=NSTextAlignmentCenter;
    NSMutableAttributedString *indroStr = [NSMutableAttributedString setupAttributeString:text rangeText:floStr textColor:HEXCOLOR(0xF3344A)];
    _currentPriceLabel.attributedText = indroStr;
    [self addSubview:_currentPriceLabel];
    //    商品原价
    _originalPriceLabel = [UILabel lableFrame:CGRectZero title:text2 backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:10] textColor:HEXCOLOR(0x666666)];
    NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:text2 lineColor:HEXCOLOR(0x666666)];
    _originalPriceLabel.attributedText = setLineStr;
    UILabel *Linelable=[[UILabel alloc]initWithFrame:CGRectMake(15, self.height-1, ScreenW-30, 1)];
    [self addSubview:Linelable];
//    [self addSubview:_originalPriceLabel];
    
   
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self)setOffset:0];
        [make.left.mas_equalTo(self)setOffset:DCMargin];
        make.size.mas_equalTo(CGSizeMake(105, 105));
    }];
    
    [_goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(_goodsImageView.mas_bottom)setOffset:5];
        [make.left.mas_equalTo(_goodsImageView)setOffset:0];
         make.size.mas_equalTo(CGSizeMake(105, 15));
       
    }];
    
    [_currentPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self.mas_bottom)setOffset:-16];
        [make.left.mas_equalTo(_goodsImageView)setOffset:0];
        [make.right.mas_equalTo(_goodsImageView)setOffset:0];
        
    }];
    
    [_originalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.top.mas_equalTo(self.mas_bottom)setOffset:-16];
        [make.right.mas_equalTo(self)setOffset:0];
      
    }];
    
 
}
-(void)reSetVDataValue:(TopProductsItem*)productInfo
{
    NSString *str=@"";
    if (productInfo.imageUrl.length > 0) {
        NSString *str3 = [productInfo.imageUrl substringToIndex:1];
        if ([str3 isEqualToString:@"/"]) {
            ManagerTools *manageTools =  [ManagerTools ManagerTools];
            if (manageTools.appInfoModel) {
                str = [NSString stringWithFormat:@"%@%@%@",manageTools.appInfoModel.imageServerUrl,productInfo.imageUrl,@"!SQ250"];
                //                            [self.iimageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
            }
        }else
        {
            str = [NSString stringWithFormat:@"%@%@",productInfo.imageUrl,@"!SQ250"];
        }
    }
    
    [_goodsImageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    
    _goodsName.text=productInfo.productName;
    NSString *str1= [HFUntilTool thousandsFload:productInfo.price];
//    NSString *str1 =[NSString stringWithFormat:@"¥%.2f",productInfo.price];
    NSRange range = [str1 rangeOfString:@"."];//匹配得到的下标
    _currentPriceLabel.attributedText = [MyUtil getAttributedWithString:str1 Color:RGBACOLOR(243, 52, 70, 1) font:[UIFont systemFontOfSize:14.0] range:NSMakeRange(1, range.location)];
//    _currentPriceLabel.text=[NSString stringWithFormat:@"%.2f",productInfo.price];

}
@end
