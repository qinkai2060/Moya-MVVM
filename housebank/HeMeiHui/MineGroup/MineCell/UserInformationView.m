//
//  UserInformationView.m
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "UserInformationView.h"
#import "UIView+addGradientLayer.h"
@implementation UserInformationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI{
    UIImageView *bgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_my_header"]];
    [self addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    //头像
    _iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _iconBtn.frame = CGRectMake(25, 75, 55,55);
    _iconBtn.tag=100;
    [_iconBtn setBackgroundImage:[UIImage imageNamed:@"tab_mine_UnActive"] forState:UIControlStateNormal];
    //    [_iconBtn setImage:[UIImage imageNamed:@"商品评论-头像"] forState:UIControlStateNormal];
    [_iconBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _iconBtn.userInteractionEnabled = YES;
    _iconBtn.layer.masksToBounds = YES;
    _iconBtn.layer.cornerRadius = _iconBtn.height/2;
    [self addSubview:_iconBtn];
    //x用户名
    _nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _nameBtn.frame = CGRectMake(100,75, 137, 30);
    _nameBtn.tag=200;
    [_nameBtn setTitle:@"" forState:UIControlStateNormal];
    [_nameBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [_nameBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _nameBtn.titleLabel.font=[UIFont systemFontOfSize:22 weight:UIFontWeightSemibold];
    [_nameBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _nameBtn.userInteractionEnabled = YES;
    [self addSubview:_nameBtn];
    
    //vip标签
    _vipTagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _vipTagBtn.frame = CGRectMake(100, 108, 58, 20);
    _vipTagBtn.tag = 1000;
    [_vipTagBtn setTitle:@"免费会员" forState:UIControlStateNormal];
    [_vipTagBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    _vipTagBtn.titleLabel.font=[UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    [_vipTagBtn.layer setCornerRadius:(_vipTagBtn.frame.size.height * 0.5)];
    _vipTagBtn.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
    _vipTagBtn.layer.borderWidth = 1.0f;
    [_vipTagBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_vipTagBtn];
    

    
    //门店会员
    _storeMemberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _storeMemberBtn.frame = CGRectMake(MaxX(_vipTagBtn) + 5, 108, 58, 20);
    _storeMemberBtn.tag = 300;
    _storeMemberBtn.hidden = YES;
    [_storeMemberBtn setTitle:@"高级门店" forState:UIControlStateNormal];
    [_storeMemberBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    _storeMemberBtn.titleLabel.font=[UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    [_storeMemberBtn.layer setCornerRadius:(_storeMemberBtn.frame.size.height * 0.5)];
    _storeMemberBtn.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
    _storeMemberBtn.layer.borderWidth = 1.0f;
    [_storeMemberBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _storeMemberBtn.userInteractionEnabled = YES;
    [self addSubview:_storeMemberBtn];
    //企业会员
    _corporateMemberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _corporateMemberBtn.frame = CGRectMake(CGRectGetMaxX(_storeMemberBtn.frame)+5, 108,58, 20);
    _corporateMemberBtn.hidden = YES;
    _corporateMemberBtn.tag=400;
    [_corporateMemberBtn setTitle:@"企业会员" forState:UIControlStateNormal];
    [_corporateMemberBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    _corporateMemberBtn.titleLabel.font=[UIFont systemFontOfSize:11 weight:UIFontWeightRegular];
    [_corporateMemberBtn.layer setCornerRadius:(_corporateMemberBtn.frame.size.height * 0.5)];
    _corporateMemberBtn.layer.borderColor = HEXCOLOR(0xDDDDDD).CGColor;
    _corporateMemberBtn.layer.borderWidth = 1.0f;
    [_corporateMemberBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _corporateMemberBtn.userInteractionEnabled = YES;
    [self addSubview:_corporateMemberBtn];
    //消息按钮
    _newsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _newsBtn.frame = CGRectMake(ScreenW - 15 - 25, IPHONEX_SAFEAREA + 15, 25, 25);
      _newsBtn.tag = 500;
    [_newsBtn setBackgroundImage:[UIImage imageNamed:@"message_light"] forState:UIControlStateNormal];
    //    [_newsBtn setImage:[UIImage imageNamed:@"message_light"] forState:UIControlStateNormal];
    [_newsBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _newsBtn.userInteractionEnabled = YES;
    [self addSubview:_newsBtn];
    //s设置按钮
    _setUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _setUpBtn.frame = CGRectMake(_newsBtn.frame.origin.x-15-25, IPHONEX_SAFEAREA + 15,25, 25);
    _setUpBtn.tag = 600;
    [_setUpBtn setBackgroundImage:[UIImage imageNamed:@"settings_light"] forState:UIControlStateNormal];
    //    [_setUpBtn setImage:[UIImage imageNamed:@"settings_light"] forState:UIControlStateNormal];
    [_setUpBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _setUpBtn.userInteractionEnabled = YES;
    [self addSubview:_setUpBtn];
    //我的资产按钮按钮
    _myAssetsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _myAssetsBtn.frame = CGRectMake(ScreenW - 68, MinY(_setUpBtn) + 55, 68, 25);
    [_myAssetsBtn addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    _myAssetsBtn.tag = 700;
    [_myAssetsBtn setImage:[UIImage imageNamed:@"qj_light666"] forState:UIControlStateNormal];
    [_myAssetsBtn setTitle:@"我的资产" forState:UIControlStateNormal];
    _myAssetsBtn.titleLabel.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [_myAssetsBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    
    CGSize titleSize = _myAssetsBtn.titleLabel.intrinsicContentSize;
    CGSize imageSize = _myAssetsBtn.imageView.bounds.size;
    NSLog(@"titleSize :%@ \n imageSize:%@",NSStringFromCGSize(titleSize),NSStringFromCGSize(imageSize));
    //文字左移
    _myAssetsBtn.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, 0.0, imageSize.width);
    //图片右移
    _myAssetsBtn.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width, 0.0, -titleSize.width);
    [_myAssetsBtn bringSubviewToFront:_myAssetsBtn.imageView];
    
    //    切角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_myAssetsBtn.bounds      byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft    cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = _myAssetsBtn.bounds;
    maskLayer.path = maskPath.CGPath;
    _myAssetsBtn.layer.mask = maskLayer;
    
    [_myAssetsBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _myAssetsBtn.userInteractionEnabled = YES;
    [self addSubview:_myAssetsBtn];
    
    _myPerformance = [UIButton buttonWithType:UIButtonTypeCustom];
    _myPerformance.hidden=YES;
    _myPerformance.frame = CGRectMake(ScreenW - 68, MaxY(_myAssetsBtn) + 5, 68, 25);
    [_myPerformance addGradualLayerWithColores:@[(id)HEXCOLOR(0xFF0000).CGColor,(id)HEXCOLOR(0xFF2E5D).CGColor]];
    _myPerformance.tag = 800;
    [_myPerformance setImage:[UIImage imageNamed:@"qj_light666"] forState:UIControlStateNormal];
    [_myPerformance setTitle:@"我的业绩" forState:UIControlStateNormal];
    _myPerformance.titleLabel.font=[UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [_myPerformance setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    CGSize titleSize2 = _myPerformance.titleLabel.intrinsicContentSize;
    CGSize imageSize2 = _myPerformance.imageView.bounds.size;
    NSLog(@"titleSize :%@ \n imageSize:%@",NSStringFromCGSize(titleSize2),NSStringFromCGSize(imageSize2));
    //文字左移
    _myPerformance.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize2.width, 0.0, imageSize2.width);
    //图片右移
    _myPerformance.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize2.width, 0.0, -titleSize2.width);
    [_myPerformance bringSubviewToFront:_myPerformance.imageView];
    
    //    切角
    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:_myPerformance.bounds      byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft    cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
    maskLayer2.frame = _myPerformance.bounds;
    maskLayer2.path = maskPath2.CGPath;
    _myPerformance.layer.mask = maskLayer2;
    
    [_myPerformance addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _myPerformance.userInteractionEnabled = YES;
    [self addSubview:_myPerformance];
    //    下划线
//    UILabel *lineLable=[[UILabel alloc]initWithFrame:CGRectMake(0, self.height-1, ScreenW, 1)];
//    lineLable.backgroundColor=HEXCOLOR(0xF5F5F5);
//    [self addSubview:lineLable];
    
    
//    _vipBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [_vipBtn setBackgroundImage:[UIImage imageNamed:@"icon_vip_bg"] forState:(UIControlStateNormal)];
//    _vipBtn.tag = 900;
//    [self addSubview:_vipBtn];
//    [_vipBtn addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
//    [_vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self).offset(20);
//        make.right.equalTo(self).offset(-20);
//        make.height.mas_equalTo(55);
//        make.bottom.equalTo(self);
//    }];
}


// 课件加号
- (void)buttonClick:(UIButton *)sender{
    switch (sender.tag) {
        case 100:
        {  //头像
            if (self.clickBlock) {
                self.clickBlock(UserInformationViewlClickTypeHeader);
            }
        }
            break;
        case 200:
        { //x用户名
            if (self.clickBlock) {
                self.clickBlock(UserInformationViewlClickTypeUserName);
            }
        }
            break;
            
        case 300:
        {//门店会员
            if (self.clickBlock) {
                self.clickBlock(UserInformationViewlClickTypeStoreVip);
            }
        }
            break;
            
        case 400:
        {   //企业会员
            if (self.clickBlock) {
                self.clickBlock(UserInformationViewlClickTypeCompanyVip);
            }
        }
            break;
            
        case 500:
        {//消息按钮
            if (self.clickBlock) {
                self.clickBlock(UserInformationViewlClickTypeMessage);
            }
        }
            break;
            
        case 600:
        {//s设置按钮
            if (self.clickBlock) {
                self.clickBlock(UserInformationViewlClickTypeSetting);
            }
        }
            break;
            
        case 700:
        { //我的资产按钮按钮
            if (self.clickBlock) {
                self.clickBlock(UserInformationViewlClickTypeMoney);
            }
        }
            break;
        case 800:
        { //我的资产按钮按钮
            if (self.clickBlock) {
                self.clickBlock(UserInformationViewlClickTypePerformance);
            }
        }
            break;
        case 900:
        { //vip
            if (self.clickBlock) {
                self.clickBlock(UserInformationViewlClickTypeVip);
            }
        }
            
            break;
        case 1000:
        { //vip tag
            if (self.clickBlock) {
                self.clickBlock(UserInformationViewlClickTypeVipTag);
            }
        }
            
            break;
        default:
            break;
    }
}
- (void)refreshHeaderWithModel:(UserInfoModel*)model
{//头像 =======
    NSString *iconStr = model.data.userCenterInfo.imagePath;
    
    [_iconBtn sd_setBackgroundImageWithURL:[iconStr get_Image] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tab_mine_UnActive"]];

//    名字
    if (model.data.userCenterInfo.name) {
        [_nameBtn setTitle:model.data.userCenterInfo.name forState:UIControlStateNormal];
    }else
    {
      [_nameBtn setTitle:model.data.userCenterInfo.nickname forState:UIControlStateNormal];
    }
    //vip会员等级(1-免费会员，2-银卡会员，3-铂金会员，4-钻石会员)
    _vipTagBtn.hidden = YES;
    switch ([model.data.userCenterInfo.vipLevel integerValue]) {
        case 1:
        {
            [_vipTagBtn setBackgroundImage:[UIImage imageNamed:@"icon_vip_mf"] forState:(UIControlStateNormal)];
        }
            break;
        case 2:
        {
            [_vipTagBtn setBackgroundImage:[UIImage imageNamed:@"icon_vip_yk"] forState:(UIControlStateNormal)];
        }
            break;
        case 3:
        {
            [_vipTagBtn setBackgroundImage:[UIImage imageNamed:@"icon_vip_bj"] forState:(UIControlStateNormal)];
        }
            break;
        case 4:
        {
            [_vipTagBtn setBackgroundImage:[UIImage imageNamed:@"icon_vip_zs"] forState:(UIControlStateNormal)];
        }
            break;

        default:
            _vipTagBtn.hidden = YES;
            break;
    }
    if (model.data.userCenterInfo.chainRoleName.length > 0) {
        [_storeMemberBtn setTitle:model.data.userCenterInfo.chainRoleName forState:UIControlStateNormal];

    }else {
        [_storeMemberBtn setTitle:@"免费会员" forState:UIControlStateNormal];
    }
    _storeMemberBtn.hidden = NO;
    CGFloat x = _vipTagBtn.hidden ? 100 : MaxX(_vipTagBtn) +5;
    _storeMemberBtn.frame = CGRectMake(x, 108, 58, 20);
    _corporateMemberBtn.frame = CGRectMake(CGRectGetMaxX(_storeMemberBtn.frame)+5, 108,58, 20);
    if (model.data.userCenterInfo.memberLevel==6) {//企业会员
        _corporateMemberBtn.hidden = NO;
        [_corporateMemberBtn setTitle:@"企业会员" forState:UIControlStateNormal];
    }else
    {
        _corporateMemberBtn.hidden=YES;
    }
    
//    if (model.data.userCenterInfo.chainRoleName && ![model.data.userCenterInfo.chainRoleName isEqualToString:@"免费会员"]) {
//         [_storeMemberBtn setTitle:model.data.userCenterInfo.chainRoleName forState:UIControlStateNormal];
//        _storeMemberBtn.hidden = NO;
//        CGFloat x = _vipTagBtn.hidden ? 100 : MaxX(_vipTagBtn) +5;
//          _storeMemberBtn.frame = CGRectMake(x, 108, 58, 20);
//        _corporateMemberBtn.frame = CGRectMake(CGRectGetMaxX(_storeMemberBtn.frame)+5, 108,58, 20);
//        if (model.data.userCenterInfo.memberLevel==6) {//企业会员
//            _corporateMemberBtn.hidden = NO;
//            [_corporateMemberBtn setTitle:@"企业会员" forState:UIControlStateNormal];
//        }else
//        {
//            _corporateMemberBtn.hidden=YES;
//        }
//    }else
//    {
//        _storeMemberBtn.hidden=YES;
//
//        CGFloat x = _vipTagBtn.hidden ? 100 : MaxX(_vipTagBtn) +5;
//
//
//        _storeMemberBtn.frame = CGRectMake(200, 108, 58, 20);
//
//        _corporateMemberBtn.frame =CGRectMake(x, 108, 58, 20);
//        if (model.data.userCenterInfo.memberLevel==6) {//企业会员
//            _corporateMemberBtn.hidden=NO;
//
//            [_corporateMemberBtn setTitle:@"企业会员" forState:UIControlStateNormal];
//        }else
//        {
//            _corporateMemberBtn.hidden=YES;
//        }
//    }
    
}

@end
