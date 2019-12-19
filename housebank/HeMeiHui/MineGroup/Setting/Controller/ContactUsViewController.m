//
//  ContactUsViewController.m
//  gcd
//
//  Created by 张磊 on 2019/4/25.
//  Copyright © 2019 张磊. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"联系我们";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}
- (void)setUI{
    UIImageView *imgLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_hflogo"]];
    [self.view addSubview:imgLogo];
    [imgLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.top.equalTo(self.view).offset(20);
    }];
    
//    UILabel *company = [[UILabel alloc] init];
//    company.text = @"合发集团股份有限公司";
//    company.textColor = HEXCOLOR(0x333333);
//    company.font = PFR16Font;
//    [self.view addSubview:company];
//    [company mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.view);
//        make.top.equalTo(imgLogo.mas_bottom).offset(10);
//        make.height.mas_equalTo(16);
//    }];
    
    UILabel *comAddress = [[UILabel alloc] init];
    comAddress.text = @"公司地址：";
    comAddress.textColor = HEXCOLOR(0x333333);
    comAddress.font = PFR14Font;
    [self.view addSubview:comAddress];
    [comAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(self.view).offset(130);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *comAddressDetail = [[UILabel alloc] init];
    comAddressDetail.text = @"上海市浦东新区张东路1388号科技领袖之都19栋";
    comAddressDetail.textColor = HEXCOLOR(0x333333);
    comAddressDetail.numberOfLines = 0;
    comAddressDetail.font = PFR14Font;
    [self.view addSubview:comAddressDetail];
    [comAddressDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(comAddress.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(comAddress);
        if (ScreenW > 375) {
            make.height.mas_equalTo(20);
        } else {
            make.height.mas_equalTo(40);
        }
    }];
    
    UILabel *comWeb= [[UILabel alloc] init];
    comWeb.text = @"官方网站：";
    comWeb.textColor = HEXCOLOR(0x333333);
    comWeb.font = PFR14Font;
    [self.view addSubview:comWeb];
    [comWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(comAddressDetail.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *comWebDetail = [[UILabel alloc] init];
    comWebDetail.text = @"http://www.hfhomes.cn";
    comWebDetail.textColor = HEXCOLOR(0x4D88FF);
    comWebDetail.userInteractionEnabled = YES;
    comWebDetail.font = PFR14Font;
    [self.view addSubview:comWebDetail];
    [comWebDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(comWeb.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(comWeb);
        make.height.mas_equalTo(20);
    }];
    
    UITapGestureRecognizer *tapweb = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWebAction)];
    [comWebDetail addGestureRecognizer:tapweb];
    
    UILabel *comPhone = [[UILabel alloc] init];
    comPhone.text = @"客服热线：";
    comPhone.textColor = HEXCOLOR(0x333333);
    comPhone.font = PFR14Font;
    [self.view addSubview:comPhone];
    [comPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(comWebDetail.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];

    UILabel *comPhoneDetail = [[UILabel alloc] init];
    comPhoneDetail.text = @"4000610908";
    comPhoneDetail.textColor = HEXCOLOR(0x4D88FF);
    comPhoneDetail.userInteractionEnabled = YES;
    comPhoneDetail.font = PFR14Font;
    [self.view addSubview:comPhoneDetail];
    [comPhoneDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(comPhone.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(comPhone);
        make.height.mas_equalTo(20);
    }];
    
    UITapGestureRecognizer *tapPhone = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhoneAction)];
    [comPhoneDetail addGestureRecognizer:tapPhone];
    
    
    
    
    UILabel *comChuanZhen = [[UILabel alloc] init];
    comChuanZhen.text = @"传      真：";
    comChuanZhen.textColor = HEXCOLOR(0x333333);
    comChuanZhen.font = PFR14Font;
    [self.view addSubview:comChuanZhen];
    [comChuanZhen mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(comPhone.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *comChuanZhenD = [[UILabel alloc] init];
    comChuanZhenD.text = @"021-64206621";
    comChuanZhenD.textColor = HEXCOLOR(0x333333);
    comChuanZhenD.userInteractionEnabled = YES;
    comChuanZhenD.font = PFR14Font;
    [self.view addSubview:comChuanZhenD];
    [comChuanZhenD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(comChuanZhen.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(comChuanZhen);
        make.height.mas_equalTo(20);
    }];
    
    
    
    UILabel *comWx = [[UILabel alloc] init];
    comWx.text = @"官方微信：";
    comWx.textColor = HEXCOLOR(0x333333);
    comWx.font = PFR14Font;
    [self.view addSubview:comWx];
    [comWx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(comChuanZhenD.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *comWxDetail = [[UILabel alloc] init];
    comWxDetail.text = @"合发";
    comWxDetail.textColor = HEXCOLOR(0x333333);
    comWxDetail.userInteractionEnabled = YES;
    comWxDetail.font = PFR14Font;
    [self.view addSubview:comWxDetail];
    [comWxDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(comWx.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(comWx);
        make.height.mas_equalTo(20);
    }];
    
    
    UILabel *comWb = [[UILabel alloc] init];
    comWb.text = @"官方微博：";
    comWb.textColor = HEXCOLOR(0x333333);
    comWb.font = PFR14Font;
    [self.view addSubview:comWb];
    [comWb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(comWxDetail.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(70, 20));
    }];
    
    UILabel *comWbDetail = [[UILabel alloc] init];
    comWbDetail.text = @"合发";
    comWbDetail.textColor = HEXCOLOR(0x333333);
    comWbDetail.userInteractionEnabled = YES;
    comWbDetail.font = PFR14Font;
    [self.view addSubview:comWbDetail];
    [comWbDetail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(comWb.mas_right).offset(5);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(comWb);
        make.height.mas_equalTo(20);
    }];
    
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    [self.view addSubview:label];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"Copyright 2011-2018, All Right Resevered.沪ICP备12001073号\n 版权所有 合发（上海）网络技术有限公司"attributes: @{NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 10],NSForegroundColorAttributeName: [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0]}];
    
    label.attributedText = string;
    label.textAlignment = NSTextAlignmentCenter;

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.mas_equalTo(40);
    }];
}

/**
 跳转网页
 */
- (void)tapWebAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.hfhomes.cn"]];
}

/**
 拨打电话
 */
- (void)tapPhoneAction{
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4000610908"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
