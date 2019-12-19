//
//  ShopDetailTableViewCell.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/16.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "ShopDetailTableViewCell.h"
#import "UILable+addSetWidthAndheight.h"
@implementation ShopDetailTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCommentView];
    }
    return self;
}
- (void)createCommentView{
    /**商品图片 */
    _pictureImg=[[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 120, 120)];
//     [self.categoryImageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    _pictureImg.image=[UIImage imageNamed:@"SpTypes_default_image"];
    [self.contentView addSubview:_pictureImg];
    /* 内容 */
    _contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(_pictureImg.rightX+15, 15, 210, 45)];
    _contentLabel.font=[UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    _contentLabel.textColor=HEXCOLOR(0x333333);
    _contentLabel.numberOfLines=0;
    [self.contentView addSubview:_contentLabel];
    /* 商品现价 */
    UIFont *font1=PFR17Font;
    CGFloat width1=[UILabel getWidthWithTitle:@"¥1002.09" font:font1];
    _currentPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(_pictureImg.rightX+15, 78.5, width1, 15)];
    _currentPriceLabel.font=PFR10Font;
    _currentPriceLabel.textColor=HEXCOLOR(0xF3344A);
     [self.contentView addSubview:_currentPriceLabel];
    /* 商品原价 */
    UIFont *font2=PFR10Font;
    CGFloat width2=[UILabel getWidthWithTitle:@"¥3484782.034" font:font2];
   _originalPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(_currentPriceLabel.rightX, 82, width2, 10)];
     _originalPriceLabel.font=PFR10Font;
     _originalPriceLabel.textColor=HEXCOLOR(0x999999);
     [self.contentView addSubview:_originalPriceLabel];
    /* 购买数 */
    UIFont *font3=PFR12Font;
    CGFloat width3=[UILabel getWidthWithTitle:@"10人购买" font:font3];
    _buyCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(ScreenW-15-width3, 82, width3, 10)];
    _buyCountLabel.font=PFR12Font;
    _buyCountLabel.textColor=HEXCOLOR(0x999999);
     [self.contentView addSubview:_buyCountLabel];
    UILabel *lableLine=[[UILabel alloc]initWithFrame:CGRectMake(15, 155, ScreenW-30, 1)];
    lableLine.backgroundColor=HEXCOLOR(0xE5E5E5);
    [self.contentView addSubview:lableLine];

}
-(void)reSetVDataValue:(PRODUCT_MODULEItem*)productModel
{
    self.productModeItem=productModel;
  
    [_pictureImg sd_setImageWithURL:[NSURL URLWithString:[productModel.imageUrl get_sharImage]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
    _contentLabel.text=productModel.productName;
    NSString *str1=@"";
    if (productModel.intrinsicPrice) {
        str1 =[NSString stringWithFormat:@"¥%.2f",productModel.intrinsicPrice];
    }else
    {
     
      str1 =[NSString stringWithFormat:@"¥%.2f",productModel.cashPrice];
    }
    NSRange range = [str1 rangeOfString:@"."];//匹配得到的下标
    _currentPriceLabel.attributedText = [MyUtil getAttributedWithString:str1 Color:RGBACOLOR(243, 52, 70, 1) font:[UIFont systemFontOfSize:14.0] range:NSMakeRange(1, range.location)];
    UIFont *font1=PFR14Font;
    CGFloat width1=[UILabel getWidthWithTitle:str1 font:font1];
    _currentPriceLabel.text=str1;
    _currentPriceLabel.width=width1;
    
    UIFont *font2=PFR10Font;
    if (productModel.intrinsicPrice) {
       
        _originalPriceLabel.hidden=NO;
    }else
    {
    
        _originalPriceLabel.hidden=YES;
    }
    NSString *str2=[NSString stringWithFormat:@"¥%.2f",productModel.cashPrice];
    NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:str2 lineColor:HEXCOLOR(0x666666)];
    CGFloat width2=[UILabel getWidthWithTitle:str2 font:font2];
    _originalPriceLabel.attributedText=setLineStr;
    _originalPriceLabel.width=width2;
    _originalPriceLabel.frame=CGRectMake(_currentPriceLabel.rightX, 82, width2, 10);
    
    UIFont *font3=PFR12Font;
    NSString *str3=@"";
    if (productModel.salesCount) {
        str3=[NSString stringWithFormat:@"%0.0f人购买",productModel.salesCount];
    }else
    {
        str3=@"0人购买";
    }
  
    CGFloat width3=[UILabel getWidthWithTitle:str3 font:font3];
    _buyCountLabel.text=str3;
    _buyCountLabel.frame=CGRectMake(ScreenW-15-width3, 82, width3, 10);
  
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
