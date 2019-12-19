//
//  HFRegsiterView.m
//  HeMeiHui
//
//  Created by usermac on 2019/3/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFRegsiterView.h"

@implementation HFRegsiterView
+ (void)show:(NSDictionary*)dict {
    HFRegsiterView *regV = [[HFRegsiterView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    NSString *str = [HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"bgUrl"]];
    [regV.bgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",str,IMGWH(CGSizeMake(regV.bgView.width,regV.bgView.height))]] placeholderImage:[UIImage imageNamed:@"invite_reg"]];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@!YS",[ManagerTools shareManagerTools].appInfoModel.imageServerUrl,[[NSUserDefaults standardUserDefaults] valueForKey:@"imagePath"]];
    [regV code:[HFUntilTool EmptyCheckobjnil:[dict valueForKey:@"qrMsg"]]];
    [regV.iconHImgV sd_setImageWithURL:[NSURL URLWithString:imageUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (image) {
            regV.iconHImgV.image = image;
        }else {
             regV.iconHImgV.image = [UIImage imageNamed:@"defualt_user"];
        }

        regV.codeView.image = [regV createNewImageWithBg:regV.codeView.image icon:regV.iconHImgV.image];
    }];
 

    regV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [[UIApplication sharedApplication].keyWindow addSubview:regV];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self removeFromSuperview];
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self hh_setupViews];
    }
    return self;
}
- (void)hh_setupViews {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.codeView];
    [self.bgView addSubview:self.iconHImgV];
    self.bgView.frame = CGRectMake((ScreenW-360)*0.5, (ScreenH-640)*0.5, 360, 640);
    CGFloat scale = 100/360;
    self.codeView.frame = CGRectMake((self.bgView.width-100)*0.5, 640-165-100, 100,  100);
    self.iconHImgV.frame = CGRectMake(0, 0, 30,  30);
    self.iconHImgV.center = self.codeView.center;
}
- (void)code:(NSString*)url{
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 3. 将字符串转换成NSData
    //    NSString *urlStr = @"http://www.ychpay.com/down.html";//测试二维码地址
//    AbstractItems *item = [[AbstractItems alloc]init];
//    NSRange range=  [item.n59 rangeOfString:@"-"];
    NSString *urlStr = @"";
    if (![urlStr hasPrefix:@"http"]) {
        urlStr = [NSString stringWithFormat:@"%@%@",fyMainHomeUrl,url];
    }else {
        urlStr = [NSString stringWithFormat:@"%@",url];
    }
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6. 将CIImage转换成UIImage，并放大显示 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    //    UIImage *codeImage = [UIImage imageWithCIImage:outputImage scale:1.0 orientation:UIImageOrientationUp];
    UIImage *codeImage  =  [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:self.codeView.width];

    self.codeView.image = codeImage;//重绘二维码,使其显示清晰
    
}
- (UIImage *)createNewImageWithBg:(UIImage *)bgImage icon:(UIImage *)icon{
    // 1.开启图片上下文
//    UIGraphicsBeginImageContext(bgImage.size);
    UIGraphicsBeginImageContextWithOptions(bgImage.size, YES,[UIScreen mainScreen].scale);
    
    // 2.绘制背景
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    // 3.绘制图标
    CGFloat iconW = 25;
    CGFloat iconH = 25;
    CGFloat iconX = (100 - iconW) * 0.5;
    CGFloat iconY = (100 - iconH) * 0.5;
    [icon drawInRect:CGRectMake(iconX, iconY, iconW, iconH)];
    
    
    // 4.取出绘制好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 5.关闭上下文
    UIGraphicsEndImageContext();
    // 6.返回生成好得图片
    return newImage;
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

- (UIImageView *)bgView {
    if (!_bgView) {
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [UIImage imageNamed:@"invite_reg"];
    }
    return _bgView;
}
- (UIImageView *)codeView {
    if (!_codeView) {
        _codeView = [[UIImageView alloc] init];
//        _codeView.backgroundColor = [UIColor redColor];
    }
    return _codeView;
}
- (UIImageView *)iconHImgV {
    if (!_iconHImgV) {
        _iconHImgV = [[UIImageView alloc] init];
        _iconHImgV.backgroundColor = [UIColor whiteColor];
        _iconHImgV.hidden = YES;
    }
    return _iconHImgV;
}
@end
