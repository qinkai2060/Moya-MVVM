//
//  AddCloudShopView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "AddCloudShopView.h"
#import "CreateWeiShopViewController.h"
#import "MyJumpHTML5ViewController.h"
@implementation AddCloudShopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel * titleLabel = [UILabel new];
        [titleLabel setText:@"新增店铺"];
        titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        titleLabel.font = kFONT(16);
        [self addSubview:titleLabel];
        self.backgroundColor = [UIColor whiteColor];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(15);
            make.centerX.equalTo(self);
            make.height.equalTo(@20);
        }];
        
        self.popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.popBtn setImage:[UIImage imageNamed:@"order_detail_cancel"] forState:UIControlStateNormal];
        [self addSubview:self.popBtn];
        [self.popBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLabel);
            make.right.equalTo(self).offset(-15);
            make.width.height.equalTo(@20);
        }];
        
        UIImageView * weiImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"weiImage"]];
        [self addSubview:weiImage];
        weiImage.userInteractionEnabled = YES;
       
        UIImageView * otoImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"otoImage"]];
        [self addSubview:otoImage];
        otoImage.userInteractionEnabled = YES;
        
        [weiImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(25);
            make.left.equalTo(self).offset(15);
            make.height.equalTo(@120);
            make.right.equalTo(otoImage.mas_left).offset(-15);
        }];
        
        [otoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(titleLabel.mas_bottom).offset(25);
            make.right.equalTo(self).offset(-15);
            make.height.equalTo(@120);
            make.width.equalTo(weiImage);
        }];

        UITapGestureRecognizer * weiTap = [[UITapGestureRecognizer alloc]init];
        [weiImage addGestureRecognizer:weiTap];
        [[weiTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            NSLog(@"进去微店");
            CreateWeiShopViewController * weiVC = [[CreateWeiShopViewController alloc]init];
            weiVC.createType = CreateNewShop;
            weiVC.canEdit = YES;
            [[UIViewController visibleViewController].navigationController pushViewController:weiVC animated:YES];
        }];
        
        UITapGestureRecognizer *otoTap = [[UITapGestureRecognizer alloc]init];
        [otoImage addGestureRecognizer:otoTap];
        [[otoTap rac_gestureSignal]subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
       
            NSString *strUrl = [NSString stringWithFormat:@"/html/home/#/xls/shop/guide"];
            MyJumpHTML5ViewController * HtmlVC = [[MyJumpHTML5ViewController alloc] init];
            HtmlVC.webUrl = strUrl;
            [[UIViewController visibleViewController].navigationController pushViewController:HtmlVC animated:YES];
        }];
    }
    return self;
}



@end
