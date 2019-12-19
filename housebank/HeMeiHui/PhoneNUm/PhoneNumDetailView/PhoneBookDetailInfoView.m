//
//  PhoneBookDetailInfoView.m
//  housebank
//
//  Created by Qianhong Li on 2017/11/2.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "PhoneBookDetailInfoView.h"
#import <UIImageView+WebCache.h>

#define ScreenWidth   [UIScreen mainScreen].bounds.size.width
/** RGB颜色 */
#define kRGB(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface PhoneBookDetailInfoView()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *phoneNumLab;
@property (nonatomic,strong) UIButton *guanZhuBtn;

@end


@implementation PhoneBookDetailInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kRGB(240, 240, 244, 1);
        [self createView];
    }
    return self;
}

- (void)createView{
    //  whiteView
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 80)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    //  iconImage
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    self.iconImage.backgroundColor = [UIColor redColor];
    [whiteView addSubview:self.iconImage];
    
    //  nameLab
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImage.frame) + 10, self.iconImage.frame.origin.y + 10, self.frame.size.width - CGRectGetMaxX(self.iconImage.frame) - 20, 20)];
    self.nameLab.font = [UIFont systemFontOfSize:16.0];
    self.nameLab.textColor = kRGB(97, 97, 97, 1);
    [whiteView addSubview:self.nameLab];
    
    //  phoneNumLab
    self.phoneNumLab = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLab.frame.origin.x, CGRectGetMaxY(self.nameLab.frame) + 5, self.nameLab.frame.size.width, self.nameLab.frame.size.height)];
    self.phoneNumLab.font = [UIFont systemFontOfSize:14.0];
    self.phoneNumLab.textColor = kRGB(169, 169, 169, 1);
    [whiteView addSubview:self.phoneNumLab];
    
    //  guanZhuBtn
    self.guanZhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.guanZhuBtn.frame = CGRectMake(ScreenWidth - 20 - 50, whiteView.frame.size.height / 2 - 20, 50, 40);
    self.guanZhuBtn.backgroundColor = [UIColor greenColor];
//    [whiteView addSubview:self.guanZhuBtn];
}

- (void)reshDetailInfoViewWithModel:(PersonInfoModel *)infoModel{
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:infoModel.contactPic] placeholderImage:[UIImage imageNamed:@"headerImage"]];
    self.nameLab.text = infoModel.contactName;
    self.phoneNumLab.text = infoModel.mobilePhone;

}

@end
