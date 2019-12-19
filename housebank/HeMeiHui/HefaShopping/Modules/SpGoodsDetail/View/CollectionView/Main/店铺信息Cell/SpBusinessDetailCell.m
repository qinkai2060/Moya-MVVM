//
//  SpBusinessDetailCell.m
//  housebank
//
//  Created by zhuchaoji on 2018/12/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "SpBusinessDetailCell.h"
#import "UIView+addGradientLayer.h"
@implementation SpBusinessDetailCell
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
    
    _storeIcon = [[UIImageView alloc] init];
    _storeIcon.contentMode = UIViewContentModeScaleAspectFit;
    _storeIcon.userInteractionEnabled = YES;
    _storeIcon.image=[UIImage imageNamed:@"icon_image"];
    [self addSubview:_storeIcon];
    
    _storeName = [[UILabel alloc] init];
    _storeName.font =[UIFont systemFontOfSize:14 weight:UIFontWeightSemibold] ;
    _storeName.textColor=HEXCOLOR(0x666666);
    _storeName.text=@"abner旗舰店";
    _storeName.lineBreakMode = NSLineBreakByTruncatingTail;
    [self addSubview:_storeName];
    
    _shopMarkLabel = [[UILabel alloc] init];
    _shopMarkLabel.font = PFR13Font;
    _shopMarkLabel.textColor=HEXCOLOR(0x666666);
//    _shopMarkLabel.text=@"良心店";
    NSMutableAttributedString *str = [NSMutableAttributedString setupAttributeString:@"" indentationText:@"良心店" indentationText:@"良心店"];
    _shopMarkLabel.attributedText = str;
//    [self addSubview:_shopMarkLabel];
    
    _contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _contactBtn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    [_contactBtn setTitle:@"联系商家" forState:UIControlStateNormal];
    _contactBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    _contactBtn.bounds=CGRectMake(0, 0, 68, 25);
    _contactBtn.tag=101;
    [_contactBtn setTitleColor:[UIColor colorWithHexString:@"F3344A"] forState:UIControlStateNormal];
    [_contactBtn addTarget:self action:@selector(storeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _contactBtn.layer.borderWidth = 1;
    _contactBtn.layer.borderColor = [UIColor colorWithHexString:@"F3344A"].CGColor;
    _contactBtn.layer.cornerRadius = _contactBtn.height/2;
    _contactBtn.layer.masksToBounds = YES;
    [self addSubview:_contactBtn];
    
    _aroundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _aroundBtn.bounds=CGRectMake(0, 0, 68, 25);
    _aroundBtn.tag=102;
    [_aroundBtn addTarget:self action:@selector(storeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //       设置渐变背景色
   [_aroundBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    [_aroundBtn setTitle:@"进店逛逛" forState:UIControlStateNormal];
    _aroundBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_aroundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _aroundBtn.layer.cornerRadius = _aroundBtn.height/2;
    _aroundBtn.layer.masksToBounds = YES;
    [self addSubview:_aroundBtn];
    
    
    _descriptionLabel = [[UILabel alloc] init];
    _descriptionLabel.font = PFR13Font;
    _descriptionLabel.textColor=HEXCOLOR(0x666666);
    _descriptionLabel.text=@"产品描述";
    [self addSubview:_descriptionLabel];
    
    _serviceLabel = [[UILabel alloc] init];
    _serviceLabel.font = PFR13Font;
    _serviceLabel.textColor=HEXCOLOR(0x666666);
    _serviceLabel.text=@"卖家服务";
    [self addSubview:_serviceLabel];
    
    _logisticsLable = [[UILabel alloc] init];
    _logisticsLable.font = PFR13Font;
    _logisticsLable.textColor=HEXCOLOR(0x666666);
    _logisticsLable.text=@"物流服务";
    [self addSubview:_logisticsLable];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_storeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(self)setOffset:DCMargin];
         [make.top.mas_equalTo(self)setOffset:5];
          make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [_storeName mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.left.mas_equalTo(_storeIcon.mas_right)setOffset:10];
        [make.top.mas_equalTo(self)setOffset:20];
        make.size.mas_equalTo(CGSizeMake(130, 20));
    }];
    
    [_shopMarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(_storeName.mas_bottom);
        make.left.mas_equalTo(_storeName.mas_left);

    }];
    
    [_aroundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(self)setOffset:-DCMargin];
        [make.top.mas_equalTo(self)setOffset:18];
       make.size.mas_equalTo(CGSizeMake(68, 25));
       
    }];
    
    [_contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        [make.right.mas_equalTo(_aroundBtn.mas_left)setOffset:-10];
        [make.top.mas_equalTo(self)setOffset:18];
        make.size.mas_equalTo(CGSizeMake(68, 25));
    }];
    
  
    
    [_descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       [make.left.mas_equalTo(self)setOffset:DCMargin];
       [make.bottom.mas_equalTo(self.mas_bottom)setOffset:-5];
       
    }];
    
    [_serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(_descriptionLabel);
    }];
    
    [_logisticsLable mas_makeConstraints:^(MASConstraintMaker *make) {
       [make.right.mas_equalTo(self)setOffset:-DCMargin];
        make.centerY.mas_equalTo(_descriptionLabel);
    }];
   
}
//店铺
-(void)storeBtnClick:(UIButton *)sender
{
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%zd",sender.tag],@"buttonTag", nil];
    switch (sender.tag) {
        case 101://联系商家
        {
            if (self.productInfo.data.product.telPhone) {
                [self telWithPhoneNum:self.productInfo.data.product.telPhone];
            }else
            {
                [self telWithPhoneNum:@"13601897864"];
            }
//               [[NSNotificationCenter defaultCenter]postNotificationName:ShopAroundAndContact object:nil userInfo:dict];
        }
            break;
        case 102://进店逛逛
        {
             [[NSNotificationCenter defaultCenter]postNotificationName:ShopAroundAndContact object:nil userInfo:dict];
        }
            break;
            
            
        default:
            break;
    }
}
#pragma mark 打电话事件
- (void)telWithPhoneNum:(NSString *)phoneNum{
    
    NSString *phone =[NSString string]; ;
    NSArray *arr = [phoneNum componentsSeparatedByString:@" "];
    if (arr.count) {
        for (NSString*str in arr) {
            phone =  [phone stringByAppendingString:str];
        }
    }
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",phoneNum];
    //    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    //    });
}
-(void)reSetVDataValue:(GoodsDetailModel*)productInfo
{
    self.productInfo=productInfo;
   
    //   商店图标
    [_storeIcon sd_setImageWithURL:[NSURL URLWithString:[productInfo.data.product.sellerAvatar get_sharImage]] placeholderImage:[UIImage imageNamed:@"SpTypes_default_image"]];
   
    
    _storeName.text=productInfo.data.product.shopName;
   
    if (productInfo.data.productComment.integratedServiceScore) {
       
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"产品描述 %.1f",productInfo.data.productComment.integratedServiceScore]];
        NSRange range1 = [[str1 string] rangeOfString:@"产品描述"];
        [str1 addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x666666) range:range1];
        NSRange range2 = [[str1 string] rangeOfString:[NSString stringWithFormat:@"%.1f",productInfo.data.productComment.integratedServiceScore]];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
        _descriptionLabel.attributedText=str1;
   
    
//         _descriptionLabel.text=[NSString stringWithFormat:@"产品描述 %.1ld",(long)productInfo.data.productComment.integratedServiceScore];
    }else
    {
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"产品描述 0.0"]];
        NSRange range1 = [[str1 string] rangeOfString:@"产品描述"];
        [str1 addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x666666) range:range1];
        NSRange range2 = [[str1 string] rangeOfString:[NSString stringWithFormat:@"0.0"]];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
        _descriptionLabel.attributedText=str1;
//         _descriptionLabel.text=@"产品描述 0.0";
    }
    if (productInfo.data.productComment.serviceAttitudeScore) {
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"卖家服务 %.1f",productInfo.data.productComment.serviceAttitudeScore]];
        NSRange range1 = [[str2 string] rangeOfString:@"卖家服务"];
        [str2 addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x666666) range:range1];
        NSRange range2 = [[str2 string] rangeOfString:[NSString stringWithFormat:@"%.1f",productInfo.data.productComment.serviceAttitudeScore]];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
        _serviceLabel.attributedText=str2;
        
//         _serviceLabel.text=[NSString stringWithFormat:@"卖家服务 %.1ld",(long)productInfo.data.productComment.serviceAttitudeScore];
    }else
    {
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"卖家服务 0.0"]];
        NSRange range1 = [[str2 string] rangeOfString:@"卖家服务"];
        [str2 addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x666666) range:range1];
        NSRange range2 = [[str2 string] rangeOfString:[NSString stringWithFormat:@"0.0"]];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
        _serviceLabel.attributedText=str2;
//        _serviceLabel.text=@"卖家服务 0.0";
    }
    if (productInfo.data.productComment.logisticsServiceScore) {
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"物流服务 %.1f",productInfo.data.productComment.logisticsServiceScore]];
        NSRange range1 = [[str3 string] rangeOfString:@"物流服务"];
        [str3 addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x666666) range:range1];
        NSRange range2 = [[str3 string] rangeOfString:[NSString stringWithFormat:@"%.1f",productInfo.data.productComment.logisticsServiceScore]];
        [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
        _logisticsLable.attributedText=str3;
//          _logisticsLable.text=[NSString stringWithFormat:@"物流服务 %.1ld",(long)productInfo.data.productComment.logisticsServiceScore];
    }else
    {
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"物流服务 0.0"]];
        NSRange range1 = [[str3 string] rangeOfString:@"物流服务"];
        [str3 addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x666666) range:range1];
        NSRange range2 = [[str3 string] rangeOfString:[NSString stringWithFormat:@"0.0"]];
        [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range2];
        _logisticsLable.attributedText=str3;
//        _logisticsLable.text=@"物流服务 0.0";
    }
  
}
@end
