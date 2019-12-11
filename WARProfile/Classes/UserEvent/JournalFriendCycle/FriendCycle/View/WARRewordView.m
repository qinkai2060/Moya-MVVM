//
//  WARRewordView.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/26.
//

#import "WARRewordView.h"
#import "WARMomentReword.h"
#import "WARMacros.h"
#import "UIImage+WARBundleImage.h"

@interface WARRewordView()
/** reword */
@property (nonatomic, strong) WARMomentReword *reword;
@end

@implementation WARRewordView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self addSubview:self.imageView];
    [self addSubview:self.valueLable];
}

- (void)configReword:(WARMomentReword *)reword {
    if (reword == nil) {
        return;
    }
    self.reword = reword;
    
    UIImage *image;
    UIColor *valueColor;
    switch (reword.rewordTypeEnum) {
        case WARMomentRewordTypeExp:
        {
            image = [UIImage war_imageName:@"map_shop_exper_sm" curClass:[self class] curBundle:@"WARProfile.bundle"];
            self.valueLable.text = [NSString stringWithFormat:@"+%@ 经验",reword.rewordVal];
            valueColor = HEXCOLOR(0x42C772);
        }
            break;
        case WARMomentRewordTypeHp:
        {
            image = [UIImage war_imageName:@"map_shop_patch_sm" curClass:[self class] curBundle:@"WARProfile.bundle"];
            self.valueLable.text = [NSString stringWithFormat:@"+%@ 碎片",reword.rewordVal];
            valueColor = HEXCOLOR(0x31A6C4);
        }
            break;
        case WARMomentRewordTypeJinBi:
        {
            image = [UIImage war_imageName:@"map_shop_gold_sm" curClass:[self class] curBundle:@"WARProfile.bundle"];
            self.valueLable.text = [NSString stringWithFormat:@"+%@ 金币",reword.rewordVal];
            valueColor = HEXCOLOR(0xF9AB10);
        }
            break;
        case WARMomentRewordTypeKaPian:
        {
            image = [UIImage war_imageName:@"map_shop_card_sm" curClass:[self class] curBundle:@"WARProfile.bundle"];
            self.valueLable.text = @"卡片";//[NSString stringWithFormat:@"%@ 卡片",reword.rewordVal];
            valueColor = HEXCOLOR(0xFD8930);
        }
            break;
            
        default:
            break;
    }
    self.imageView.image = image;
    self.valueLable.textColor = valueColor; 
}

- (UIImage *)currentViewImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[UIScreen mainScreen] scale]);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImageView *)currentImageInView {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [[UIScreen mainScreen] scale]);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    imageView.image = image;
    return imageView;
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 15, 15)]; 
        _imageView.layer.masksToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (UILabel *)valueLable {
    if (!_valueLable) {
        _valueLable = [[UILabel alloc]init];
        _valueLable.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
        _valueLable.textAlignment = NSTextAlignmentCenter;
    }
    return _valueLable;
}

@end
