//
//  CloudCodeView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/6/6.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "CloudCodeView.h"
#import "CloudManageBtn.h"
@interface CloudCodeView ()
@property (nonatomic, strong) CloudManageBtn * codeBtn;
@property (nonatomic, strong) UILabel * titleLabel;
@end
@implementation CloudCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *backView = [UIView new];
        backView.alpha = 0.5;
        backView.backgroundColor = [UIColor blackColor];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@(kHeight - 450));
        }];
        
        UIView * whiteView  = [UIView new];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self addSubview:whiteView];
        [whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@450);
        }];
        
        self.titleLabel = [UILabel new];
        self.titleLabel.text = [NSString stringWithFormat:@"{%@}",objectOrEmptyStr(self.titleString)];
        self.titleLabel.textColor = [UIColor colorWithHexString:@"#333333"];
        self.titleLabel.font = kFONT_BOLD(17);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [whiteView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(whiteView).offset(22);
            make.centerX.equalTo(whiteView);
            make.height.equalTo(@24);
        }];
        
        UILabel * alertLabel = [UILabel new];
        alertLabel.text = @"保存二维码，打印成传单，让更多人更快找到我的店铺";
        alertLabel.textColor = [UIColor colorWithHexString:@"#666666"];
        alertLabel.font = kFONT(12);
        alertLabel.textAlignment = NSTextAlignmentCenter;
        [whiteView addSubview:alertLabel];
        [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
            make.centerX.equalTo(whiteView);
            make.height.equalTo(@20);
        }];
        
        self.codeImageView = [[UIImageView alloc]init];
        [whiteView addSubview:self.codeImageView];
        [self.codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(alertLabel.mas_bottom).offset(30);
            make.width.height.equalTo(@235);
            make.centerX.equalTo(whiteView);
        }];
        
        self.codeBtn = [[CloudManageBtn alloc]init];
        [self.codeBtn initWithLayerWidth:kWidth-80 font:14 height:40];
        [self.codeBtn setTitle:@"保存二维码" forState:UIControlStateNormal];
        [whiteView addSubview:self.codeBtn];
        [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(whiteView);
            make.height.equalTo(@40);
            make.bottom.equalTo(whiteView).offset(-41);
            make.width.equalTo(@(kWidth - 80));
        }];
        
        @weakify(self);
        [[self.codeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self closeAnimation];
            if (self.codeBlcok) {
                self.codeBlcok();
            }
        }];
    }
    return self;
}

- (void)initWithCodeString:(NSString *)codeString codeBlock:(nonnull codeBlock)codeBlock {
    self.titleLabel.text = [NSString stringWithFormat:@"{%@}",objectOrEmptyStr(self.titleString)];
    self.codeBlcok = codeBlock;
    self.codeImageView.image = [self getCodeImageWithCodeString:codeString];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.missBlock) {
        self.missBlock();
    }
    [self closeAnimation];
}

- (void)popAnimation {
    
    [UIView animateWithDuration:0.35 animations:^{
          self.frame = CGRectMake(0, 0, kWidth, kHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)closeAnimation {
    
    [UIView animateWithDuration:0.35 animations:^{
        self.frame = CGRectMake(0, kHeight, kWidth, kHeight);
    } completion:^(BOOL finished) {
  
    }];
}

// 二维码生成
- (UIImage *)getCodeImageWithCodeString:(NSString *)codeString {
 
     CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
     [filter setDefaults];
     NSString *string = objectOrEmptyStr(codeString);
     NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
     [filter setValue:data forKeyPath:@"inputMessage"];
     CIImage *image = [filter outputImage];
     return [self createNonInterpolatedUIImageFormCIImage:image withSize:235];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
     CGRect extent = CGRectIntegral(image.extent);
     CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
     // 1.创建bitmap;
     size_t width = CGRectGetWidth(extent) * scale;
     size_t height = CGRectGetHeight(extent) * scale;
     CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
     CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
     CIContext *context = [CIContext contextWithOptions:nil];
     CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
     CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
     CGContextScaleCTM(bitmapRef, scale, scale);
     CGContextDrawImage(bitmapRef, extent, bitmapImage);
     // 2.保存bitmap到图片
     CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
     CGContextRelease(bitmapRef);
     CGImageRelease(bitmapImage);
     return [UIImage imageWithCGImage:scaledImage];
}
@end
