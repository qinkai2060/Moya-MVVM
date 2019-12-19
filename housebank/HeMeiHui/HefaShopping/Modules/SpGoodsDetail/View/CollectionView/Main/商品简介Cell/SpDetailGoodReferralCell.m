//
//  SpDetailGoodReferralCell.m
//  housebank
//
//  Created by zhuchaoji on 2018/11/17.
//  Copyright © 2018年 hefa. All rights reserved.
//
#import "SpDetailGoodReferralCell.h"
#import "DCUpDownButton.h"
#import "UIButton+CustomButton.h"
#import "NSString+Extention.h"
@interface SpDetailGoodReferralCell ()

/* 自营 */
@property (strong , nonatomic)UIImageView *autotrophyImageView;
/* 分享按钮 */
@property (strong , nonatomic)DCUpDownButton *shareButton;

@end

@implementation SpDetailGoodReferralCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    NSString *text = @"¥3500.10";
    NSString *floStr;NSString *intStr;
    NSString *text2 = @"¥8500";
    if ([text containsString:@"."]) {
        NSRange range = [text rangeOfString:@"."];
        floStr = [text substringFromIndex:range.location];
        intStr = [text substringToIndex:range.location];
    }
//    商品现价
    _currentPriceLabel = [UILabel lableFrame:CGRectZero title:text backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:16] textColor:HEXCOLOR(0xF3344A)];
    NSMutableAttributedString *indroStr = [NSMutableAttributedString setupAttributeString:text rangeText:floStr textColor:HEXCOLOR(0xF3344A)];
    _currentPriceLabel.attributedText = indroStr;
    [self.contentView addSubview:_currentPriceLabel];
//    商品原价
    _originalPriceLabel = [UILabel lableFrame:CGRectZero title:text2 backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:10] textColor:HEXCOLOR(0x666666)];
    NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:@"¥8500" lineColor:HEXCOLOR(0x666666)];
    _originalPriceLabel.attributedText = setLineStr;
    [self.contentView addSubview:_originalPriceLabel];
    
    //单价最低
    [self.contentView addSubview:self.minimumUnitPrice];
    
//  商品标题含标签
    _titleLabel = [UILabel lableFrame:CGRectZero title:@"价值3500元 GUCCI古驰 黑色牛皮做旧时尚男士腰带" backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:16 weight:UIFontWeightSemibold] textColor:HEXCOLOR(0x333333)];
    _titleLabel.numberOfLines = 0;
   NSMutableAttributedString *str= [NSMutableAttributedString setupAttributeString:@"价值3500元 GUCCI古驰 黑色牛皮做旧时尚男士腰带" indentationText:@"良心店" indentationText:@"I类"];
//    NSMutableAttributedString *str = [NSMutableAttributedString setupAttributeString:@"价值3500元 GUCCI古驰 黑色牛皮做旧时尚男士腰带" indentationText:@"良心店"];
    _titleLabel.attributedText = str;
    [self.contentView addSubview:_titleLabel];
//    子标题
    _subtitleLabel=[UILabel lableFrame:CGRectZero title:@"价值3500元 GUCCI古驰 黑色牛皮做旧时尚男士腰带" backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular] textColor:HEXCOLOR(0x666666)];
    _subtitleLabel.numberOfLines = 0;
    [self.contentView addSubview:_subtitleLabel];
//vip返利
    [self.contentView addSubview:self.vipFlBtn];
    

//  月销量
    _monthlySalesLabel = [UILabel lableFrame:CGRectZero title:@"月销1254" backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:13] textColor:HEXCOLOR(0x333333)];
    [self.contentView addSubview:_monthlySalesLabel];
//   地址
    _addressLabel = [UILabel lableFrame:CGRectZero title:@"浙江 杭州" backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:13] textColor:HEXCOLOR(0x333333)];
    _addressLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_addressLabel];
    
    //vip领取优惠券
    [self.contentView addSubview:self.vipGetCoupon];
 
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self.vipGetCoupon addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.vipGetCoupon);
        make.right.equalTo(self.vipGetCoupon);
        make.top.equalTo(self.vipGetCoupon);
        make.height.mas_equalTo(1);
    }];
    
    UILabel *coupon = [UILabel lableFrame:CGRectZero title:@"优惠券" backgroundColor:[UIColor clearColor] font:[UIFont systemFontOfSize:13] textColor:HEXCOLOR(0x333333)];
    [self.vipGetCoupon addSubview:coupon];
    [coupon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.vipGetCoupon);
        make.left.equalTo(self.vipGetCoupon).offset(15);
    }];
    
    UIButton *getCouponBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [getCouponBtn setTitle:@"领券" forState:(UIControlStateNormal)];
    getCouponBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [getCouponBtn setTitleColor:HEXCOLOR(0x333333) forState:(UIControlStateNormal)];
    [getCouponBtn setImage:[UIImage imageNamed:@"back_light666"] forState:(UIControlStateNormal)];
    [getCouponBtn addTarget:self action:@selector(vipGetCouponAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self.vipGetCoupon addSubview:getCouponBtn];
    [getCouponBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.vipGetCoupon).offset(-15);
        make.top.equalTo(self.vipGetCoupon);
        make.height.equalTo(self.vipGetCoupon);
        make.width.mas_equalTo(50);
    }];
    
    [getCouponBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    
//    咨询
    _consultationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _consultationBtn.frame=CGRectMake(ScreenW-50-15, self.height-30, 50, 20);
    // 创建imageview
   _image = [UIImage imageNamed:@"news_hot_light"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    [imageView setImage:_image];
    // 创建label
    _label = [[UILabel alloc] initWithFrame:CGRectMake(20,0,30,20)];
    [_label setText:@"咨讯"];
    _label.font=[UIFont systemFontOfSize:13];
    _label.textColor=HEXCOLOR(0x333333);
    // 添加到button中
    [_consultationBtn addSubview:_label];
    [_consultationBtn addSubview:imageView];
    [_consultationBtn addTarget:self action:@selector(seaTheConsultationClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_consultationBtn];

   

//    _consultationBtn=[UIButton]
//    [DCSpeedy dc_setUpAcrossPartingLineWith:self WithColor:[[UIColor lightGrayColor]colorWithAlphaComponent:0.15]];
    
}


-(void)reSetVDataValue:(Product*)productInfo  allData:(GoodsDetailModel*)goodDetail
{
      if (![self.code isEqualToString:@""]&&self.code) {
              if (self.skuItemIntrinsicPrice&&[self.skuItemIntrinsicPrice integerValue]!=0&&![self.skuItemIntrinsicPrice isEqualToString:@""]&&![self.skuItemIntrinsicPrice isEqualToString:self.skuItemPrice]) {
                  _originalPriceLabel.hidden=NO;
              }else
              {
                  _originalPriceLabel.hidden=YES;
              }
          NSString *str =[HFUntilTool thousandsFload:[self.skuItemPrice floatValue]];
          NSRange range = [str rangeOfString:@"."];//匹配得到的下标
          _currentPriceLabel.attributedText = [MyUtil getAttributedWithString:str Color:RGBACOLOR(243, 52, 70, 1) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range.location)];
          NSMutableAttributedString *setLineStr;
          if (goodDetail.data.product.commodityType == 6) {
              setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"市场价%@",[HFUntilTool thousandsFload:[self.skuItemIntrinsicPrice floatValue]]] lineColor:HEXCOLOR(0x666666)];
          }else
          {
             setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:[self.skuItemIntrinsicPrice floatValue]]] lineColor:HEXCOLOR(0x666666)];
          }
         
          _originalPriceLabel.attributedText=setLineStr;
      }else
      {
         
          NSString *str =[HFUntilTool thousandsFload:productInfo.price];
          NSRange range = [str rangeOfString:@"."];//匹配得到的下标
          _currentPriceLabel.attributedText = [MyUtil getAttributedWithString:str Color:RGBACOLOR(243, 52, 70, 1) font:[UIFont systemFontOfSize:24.0] range:NSMakeRange(1, range.location)];
          
            NSMutableAttributedString *setLineStr;
          if (goodDetail.data.product.commodityType == 6) {
              setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"市场价%@",[HFUntilTool thousandsFload:self.productInfo.intrinsicPrice ]] lineColor:HEXCOLOR(0x666666)];
          }else
          {
              setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:self.productInfo.intrinsicPrice ]] lineColor:HEXCOLOR(0x666666)];
          }
//          NSMutableAttributedString *setLineStr = [NSMutableAttributedString setupAttributeLine:[NSString stringWithFormat:@"%@",[HFUntilTool thousandsFload:self.productInfo.intrinsicPrice]] lineColor:HEXCOLOR(0x666666)];
          _originalPriceLabel.attributedText=setLineStr;
      }
   
    NSString *productLevel=@"";
  
    if (goodDetail.data.product.productLevel) {
        switch (goodDetail.data.product.productLevel) {
            case 1:
            {
                productLevel=@"I类";
            }
                break;
            case 2:
            {
                 productLevel=@"II类";
            }
                break;
            case 3:
            {
                 productLevel=@"III类";
            }
                break;
                
                
            default:
                break;
        }
    }
    NSMutableAttributedString *titlestr;
    if (self.spaceTime>0) {
        if (goodDetail.data.productActiveChk.activeTitle) {
            titlestr=[NSMutableAttributedString setupAttributeString:goodDetail.data.productActiveChk.activeTitle indentationText:goodDetail.data.promotionTag indentationText:productLevel];
            _titleLabel.attributedText=titlestr;
        }else
        {
            titlestr=[NSMutableAttributedString setupAttributeString:productInfo.title indentationText:goodDetail.data.promotionTag indentationText:productLevel];
            _titleLabel.attributedText=titlestr;
        }
    }else
    {
        titlestr=[NSMutableAttributedString setupAttributeString:productInfo.title indentationText:@"" indentationText:@""];
        _titleLabel.attributedText=titlestr;
    }
   
   

    if (_titleLabel.attributedText.length>0) {
        NSMutableAttributedString *attributedString =titlestr;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:7];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [_titleLabel.attributedText length])];
        _titleLabel.attributedText = attributedString;
        _titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    _subtitleLabel.text=goodDetail.data.product.productSubtitle;
    if ([NSString stringWithFormat:@"%ld",(long)productInfo.initialNumber]!=nil&&![[NSString stringWithFormat:@"%ld",(long)productInfo.initialNumber] isEqualToString:@""]) {
         _monthlySalesLabel.text=[NSString stringWithFormat:@"月销%ld",(long)productInfo.initialNumber];
    }else
    {
        _monthlySalesLabel.text=@"月销0";
    }
    if (productInfo.cityName.length>0||productInfo.regionName>0) {
        _addressLabel.text=[NSString stringWithFormat:@"%@  %@",productInfo.cityName,productInfo.regionName];
    }else
    {
        _addressLabel.text=@"";
    }
    CGSize size = [_addressLabel sizeThatFits:CGSizeMake(ScreenW-30-60-15, 15)];
    if ([[NSString stringWithFormat:@"%ld",(long)goodDetail.data.productConsult] isEqualToString:@""]||[NSString stringWithFormat:@"%ld",(long)goodDetail.data.productConsult]==nil||[[NSString stringWithFormat:@"%ld",(long)goodDetail.data.productConsult] isEqualToString:@"0"]) {
        _consultationBtn.hidden=YES;
        [_addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
            make.width.equalTo(@(size.width));
            [make.bottom.mas_equalTo(self.contentView.mas_bottom)setOffset:-10];
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }else
    {
        _consultationBtn.hidden=YES;
        [_addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@15);
            make.width.equalTo(@(size.width));
            [make.bottom.mas_equalTo(self.contentView.mas_bottom)setOffset:-10];
            make.right.equalTo(self.contentView).offset(-15);
        }];

    }
    if (goodDetail.data.seckillInfo.noticeActivityStart) {//秒杀预告
        _currentPriceLabel.hidden=YES;
        _originalPriceLabel.hidden=YES;
        _currentPriceLabel.hidden=YES;
        _originalPriceLabel.hidden=YES;
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
            [make.top.mas_equalTo(self.contentView)setOffset:10];
            [make.right.mas_equalTo(self.contentView)setOffset:-DCMargin];
        }];
        [_monthlySalesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
            [make.bottom.mas_equalTo(self.contentView.mas_bottom)setOffset:-10];
        }];
        
        [_subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
            [make.top.mas_equalTo(_titleLabel.mas_bottom)setOffset:5];
            [make.right.mas_equalTo(self.contentView)setOffset:-DCMargin];
        }];
    }else if (goodDetail.data.seckillInfo.isSeckill==1)//秒杀中
    {
        _currentPriceLabel.hidden=YES;
        _originalPriceLabel.hidden=YES;
        _currentPriceLabel.hidden=YES;
        _originalPriceLabel.hidden=YES;
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
            [make.top.mas_equalTo(self.contentView)setOffset:10];
            [make.right.mas_equalTo(self.contentView)setOffset:-DCMargin];
        }];
        [_monthlySalesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
            [make.bottom.mas_equalTo(self.contentView.mas_bottom)setOffset:-10];
        }];
        
        [_subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
            [make.top.mas_equalTo(_titleLabel.mas_bottom)setOffset:5];
            [make.right.mas_equalTo(self.contentView)setOffset:-DCMargin];
        }];
    }else
    {
        if ([self.spaceTime integerValue]>0) {
            _currentPriceLabel.hidden=YES;
            _originalPriceLabel.hidden=YES;
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
                [make.top.mas_equalTo(self.contentView)setOffset:10];
                [make.right.mas_equalTo(self.contentView)setOffset:-DCMargin];
            }];
            [_monthlySalesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
                [make.bottom.mas_equalTo(self.contentView.mas_bottom)setOffset:-10];
            }];
            
            [_subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
                [make.top.mas_equalTo(_titleLabel.mas_bottom)setOffset:5];
                [make.right.mas_equalTo(self.contentView)setOffset:-DCMargin];
            }];
            //        [_addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            [make.bottom.mas_equalTo(self.contentView.mas_bottom)setOffset:-10];
            //            [make.centerX.mas_equalTo(_titleLabel.centerX)setOffset:0];
            //            //        [make.right.mas_equalTo(self)setOffset:-DCMargin];
            //        }];
        }else
        {
            if (![self.code isEqualToString:@""]&&self.code) {
                if (self.skuItemIntrinsicPrice&&[self.skuItemIntrinsicPrice integerValue]!=0&&![self.skuItemIntrinsicPrice isEqualToString:@""]&&![self.skuItemIntrinsicPrice isEqualToString:self.skuItemPrice]) {
                    _originalPriceLabel.hidden=NO;
                }else
                {
                    _originalPriceLabel.hidden=YES;
                }
            }else
            {
                
                if(productInfo.intrinsicPrice&&productInfo.intrinsicPrice>0&&![[NSString stringWithFormat:@"%f",self.productInfo.intrinsicPrice] isEqualToString:[NSString stringWithFormat:@"%f",self.productInfo.price]]) {
                    _originalPriceLabel.hidden=NO;
                }else
                {
                    _originalPriceLabel.hidden=YES;
                }
            }
           
            _currentPriceLabel.hidden=NO;
            [_currentPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make){
                [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
                [make.top.mas_equalTo(self.contentView)setOffset:10];
            }];
            
            [_originalPriceLabel mas_remakeConstraints:^(MASConstraintMaker *make){
                [make.left.mas_equalTo(_currentPriceLabel.mas_right)setOffset:DCMargin];
                [make.top.mas_equalTo(self.contentView)setOffset:23];
            }];
            
            [self.minimumUnitPrice mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_originalPriceLabel);
                make.right.equalTo(self.contentView).offset(-DCMargin);
                make.height.mas_equalTo(25);
            }];
            [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
                [make.top.mas_equalTo(_currentPriceLabel.mas_bottom)setOffset:10];
                [make.right.mas_equalTo(self.contentView)setOffset:-DCMargin];
            }];
            [_subtitleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
                [make.top.mas_equalTo(_titleLabel.mas_bottom)setOffset:5];
                [make.right.mas_equalTo(self.contentView)setOffset:-DCMargin];
            }];
            
            //vip返利
            if (goodDetail.data.product.vipRebateInfo && goodDetail.data.product.vipRebateInfo.rebate && goodDetail.data.product.vipRebateInfo.vipLevel && goodDetail.data.product.vipRebateInfo.rebate > 0 ) {
                _vipFlBtn.hidden = NO;
                [_vipFlBtn setTitle:[NSString stringWithFormat:@"%@会员此商品单件最高可返¥%.2f", [self vipNameForVipLevel:goodDetail.data.product.vipRebateInfo.vipLevel],goodDetail.data.product.vipRebateInfo.rebate] forState:(UIControlStateNormal)];
                [_vipFlBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                    [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
                    if (CHECK_STRING_ISNULL(goodDetail.data.product.productSubtitle) ||
                        [goodDetail.data.product.productSubtitle isEqualToString:@""]) {
                        [make.top.mas_equalTo(_subtitleLabel.mas_bottom)setOffset:0];
                    } else {
                        [make.top.mas_equalTo(_subtitleLabel.mas_bottom)setOffset:DCMargin];
                    }
                    [make.right.mas_equalTo(self.contentView)setOffset:-DCMargin];
                    make.height.mas_offset(35);
                }];
                [self layoutIfNeeded];
                [_vipFlBtn setImageEdgeInsets:UIEdgeInsetsMake(10, _vipFlBtn.width - 25, 10, 10)];

            } else {
                _vipFlBtn.hidden = YES;
            }
            
            
            //领取优惠券
            if (goodDetail.data.product.isWholesaleProduct &&
                goodDetail.data.product.isWholesaleProduct == 1 && goodDetail.data.product.commodityType == 6
                ) {
                _vipGetCoupon.hidden = NO;//领取优惠券
                [_vipGetCoupon mas_remakeConstraints:^(MASConstraintMaker *make) {
                    [make.left.mas_equalTo(self.contentView)setOffset:0];
                    [make.bottom.mas_equalTo(self.contentView.mas_bottom)setOffset:0];
                    [make.right.mas_equalTo(self.contentView)setOffset:0];
                    make.height.mas_offset(45);
                }];
                [_monthlySalesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
                    [make.bottom.mas_equalTo(self.vipGetCoupon.mas_top)setOffset:-10];
                }];
                [_addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.mas_equalTo(_monthlySalesLabel);
                    make.right.equalTo(self.contentView).offset(-15);
                }];
              
            } else {
                _vipGetCoupon.hidden = YES;
                [_monthlySalesLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                    [make.left.mas_equalTo(self.contentView)setOffset:DCMargin];
                    [make.bottom.mas_equalTo(self.contentView.mas_bottom)setOffset:-10];
                }];
            }
            
            if (goodDetail.data.product.isWholesaleProduct &&
                goodDetail.data.product.isWholesaleProduct == 1 &&
                goodDetail.data.product.vipProduct &&
                goodDetail.data.product.vipProduct.productPrice &&
                goodDetail.data.product.vipProduct.productPrice > 0 &&
                goodDetail.data.product.commodityType == 6
                ) {
               
                _minimumUnitPrice.hidden = NO;
                _minimumUnitPrice.attributedText = [NSString stringWithFormat:@"单价最低%.2f元",goodDetail.data.product.vipProduct.productPrice].addBlank3;
            } else {
                _minimumUnitPrice.hidden = YES;
              
            }
            
        }
        
    }
    
    
}
- (NSString *)vipNameForVipLevel:(NSInteger)level{
    NSString *str = @"";
    switch (level) {
        case 1:
            str = @"免费会员";
            break;
        case 2:
            str = @"银卡会员";
            break;
        case 3:
            str = @"铂金会员";
            break;
        case 4:
            str = @"钻石会员";
            break;
            
        default:
            break;
    }
    return str;
}
#pragma mark - 分享按钮点击
- (void)shareButtonClick
{
    !_shareButtonClickBlock ? : _shareButtonClickBlock();
}
//   查看咨询
-(void)seaTheConsultationClick
{
//     NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:[NSString stringWithFormat:@"%zd",sender.tag],@"buttonTag", nil];
     [[NSNotificationCenter defaultCenter]postNotificationName:SeaConsultationDetail object:nil userInfo:nil];
}
- (UIButton *)vipFlBtn{
    if(!_vipFlBtn){
        _vipFlBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_vipFlBtn setBackgroundImage:[UIImage imageNamed:@"icon_vipDetail_flbg"] forState:(UIControlStateNormal)];
        [_vipFlBtn setImage:[UIImage imageNamed:@"back_light666"] forState:(UIControlStateNormal)];
        [_vipFlBtn setTitleColor:HEXCOLOR(0xFFE8AC) forState:(UIControlStateNormal)];
        _vipFlBtn.hidden = YES;
        [_vipFlBtn addTarget:self action:@selector(vipFlBtnAction) forControlEvents:(UIControlEventTouchUpInside)];
        _vipFlBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _vipFlBtn;
}
- (void)vipFlBtnAction{
    if (self.clickBlock) {
        self.clickBlock(GoodsDetailClickTypeGiveProfit);
    }
}
- (UIView *)vipGetCoupon{
    if (!_vipGetCoupon) {
        _vipGetCoupon = [[UIView alloc] init];
        _vipGetCoupon.hidden = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vipGetCouponAction)];
        [_vipGetCoupon addGestureRecognizer:tap];
    }
    return _vipGetCoupon;
}
- (void)vipGetCouponAction{
    if (self.clickBlock) {
        self.clickBlock(GoodsDetailClickTypeGetCoupon);//领取优惠券
    }
}
- (UILabel *)minimumUnitPrice{
    if (!_minimumUnitPrice) {
        _minimumUnitPrice = [[UILabel alloc] init];
        _minimumUnitPrice.textColor = [UIColor whiteColor];
        _minimumUnitPrice.font = [UIFont systemFontOfSize:12];
        _minimumUnitPrice.backgroundColor = HEXCOLOR(0xFF0000);
        _minimumUnitPrice.layer.cornerRadius = 12.5;
        _minimumUnitPrice.hidden = YES;
        _minimumUnitPrice.layer.masksToBounds = YES;
        _minimumUnitPrice.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(minimumUnitPriceAction)];
        [_minimumUnitPrice addGestureRecognizer:tap];
    }
    return _minimumUnitPrice;
}
- (void)minimumUnitPriceAction{
    if (self.clickBlock) {
        self.clickBlock(GoodsDetailClickTypeWholesale);//批发可享
    }
}
#pragma mark - Setter Getter Methods


@end
