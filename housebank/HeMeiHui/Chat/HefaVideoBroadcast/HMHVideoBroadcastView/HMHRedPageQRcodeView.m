//
//  HMHRedPageQRcodeView.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/31.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHRedPageQRcodeView.h"
#import "SGQRCodeTool.h"
#import "TZImageManager.h"


@interface HMHRedPageQRcodeView()
@property (nonatomic, strong) UIImage *HMH_qrImage;
@end
@implementation HMHRedPageQRcodeView

- (instancetype)initWithFrame:(CGRect)frame topName:(NSString *)title QRCodeUrl:(NSString *)codeUrl bottomStr:(NSString *)bottmStr{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUIWithTopTitle:title QRCodeUrl:codeUrl bottomStr:bottmStr];
    }
    return self;
}

- (void)createUIWithTopTitle:(NSString *)topTitle QRCodeUrl:(NSString *)codeUrl bottomStr:(NSString *)bottomStr{
    self.backgroundColor = [UIColor clearColor];
    
    // alphaView
    UIView *alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    alphaView.backgroundColor = [UIColor blackColor];
    alphaView.alpha = 0.7;
    [self addSubview:alphaView];
    
     UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [alphaView addGestureRecognizer:singleTap];
    
    //
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(30, ScreenH / 2 - (ScreenH / 4 * 3) / 2 + 40, ScreenW - 30 * 2, ScreenH /4 * 3 - 80)];
    whiteView.backgroundColor = [UIColor whiteColor];
    whiteView.layer.masksToBounds = YES;
    whiteView.layer.cornerRadius = 5.0;
    [self addSubview:whiteView];
    
    //
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whiteView.frame.size.width, 40)];
    titleLab.backgroundColor = RGBACOLOR(195, 195, 195, 1);
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:15.0];
    titleLab.text = topTitle;
    [whiteView addSubview:titleLab];
    
    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame =CGRectMake(40,whiteView.frame.size.height / 2 - (whiteView.frame.size.width - 80) / 2, whiteView.frame.size.width - 80,whiteView.frame.size.width - 80);

    [whiteView addSubview:imageView];
    
    // 2、将CIImage转换成UIImage，并放大显示
    _HMH_qrImage = [SGQRCodeTool SG_generateWithDefaultQRCodeData:codeUrl imageViewWidth: whiteView.frame.size.width - 80];
    
    imageView.image = _HMH_qrImage;
    //
    UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, whiteView.frame.size.height - 40, whiteView.frame.size.width, 40)];
    bottomLab.backgroundColor = RGBACOLOR(195, 195, 195, 1);
    bottomLab.textAlignment = NSTextAlignmentCenter;
    bottomLab.font = [UIFont systemFontOfSize:15.0];
    bottomLab.text = bottomStr;
    [whiteView addSubview:bottomLab];
    
    //
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, bottomLab.frame.origin.y, bottomLab.frame.size.width, bottomLab.frame.size.height);
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(dowmLoadImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:btn];
    
}

- (void)dowmLoadImageClick:(UIButton *)btn{
    // 目的是为了请求权限
    [[TZImageManager manager] savePhotoWithImage:[[UIImage alloc] init] completion:^(PHAsset *asset,NSError *error) {
    }];

    
    [[TZImageManager manager] savePhotoWithImage:_HMH_qrImage completion:^(PHAsset *asset,NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:@"保存到相册成功"];
            [SVProgressHUD dismissWithDelay:1];

        } else {
            [SVProgressHUD showErrorWithStatus:@"保存到相册失败"];
            [SVProgressHUD dismissWithDelay:1];
        }
        [self hide];
    }];
}

// 生成二维码 (暂且没用到)
- (void)setupGenerateQRCode {
    
    // 1、借助UIImageView显示二维码
    UIImageView *imageView = [[UIImageView alloc] init];
    CGFloat imageViewW = 150;
    CGFloat imageViewH = imageViewW;
    CGFloat imageViewX = (self.frame.size.width - imageViewW) / 2;
    CGFloat imageViewY = 80;
    imageView.frame =CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
    [self addSubview:imageView];
    
    // 2、将CIImage转换成UIImage，并放大显示
    imageView.image = [SGQRCodeTool SG_generateWithDefaultQRCodeData:@"https://www.baidu.com" imageViewWidth:imageViewW];
    
#pragma mark - - - 模仿支付宝二维码样式（添加用户头像）
    CGFloat scale = 0.22;
    CGFloat borderW = 5;
    UIView *borderView = [[UIView alloc] init];
    CGFloat borderViewW = imageViewW * scale;
    CGFloat borderViewH = imageViewH * scale;
    CGFloat borderViewX = 0.5 * (imageViewW - borderViewW);
    CGFloat borderViewY = 0.5 * (imageViewH - borderViewH);
    borderView.frame = CGRectMake(borderViewX, borderViewY, borderViewW, borderViewH);
    borderView.layer.borderWidth = borderW;
    borderView.layer.borderColor = [UIColor purpleColor].CGColor;
    borderView.layer.cornerRadius = 10;
    borderView.layer.masksToBounds = YES;
    borderView.layer.contents = (id)[UIImage imageNamed:@"icon_image"].CGImage;
    
    //[imageView addSubview:borderView];
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    [self hide];
}

- (void)show{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}

- (void)hide{
    if (self.superview) {
        [self removeFromSuperview];
    }
}

@end
