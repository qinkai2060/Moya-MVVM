//
//  VipGiftFotterView.m
//  HeMeiHui
//
//  Created by Tracy on 2019/9/20.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "VipGiftFotterView.h"
#import "NSString+Person.h"
#import "MyUtil.h"
@implementation VipGiftFotterView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        //   UIImageView * firstImage = [self add_allFotterImageWithID:@"footerBg_01"];
        UIImageView * firstImage = [[UIImageView alloc]init];
        [firstImage sd_setImageWithURL:[self getImageURLWithImageString:@"footerBg_01"]];
        [self addSubview:firstImage];
        [firstImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@180);
        }];
        
        //   UIImageView * secondImage = [self add_allFotterImageWithID:@"footerBg_02"];
        UIImageView * secondImage = [[UIImageView alloc]init];
        [secondImage sd_setImageWithURL:[self getImageURLWithImageString:@"footerBg_02"]];
        [self addSubview:secondImage];
        [secondImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(firstImage.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@375);
        }];

        //   UIImageView * thirdImage = [self add_allFotterImageWithID:@"footerBg_03"];
        UIImageView * thirdImage = [[UIImageView alloc]init];
        [thirdImage sd_setImageWithURL:[self getImageURLWithImageString:@"footerBg_03"]];
        [self addSubview:thirdImage];
        [thirdImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(secondImage.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@200);
        }];
        
        //   UIImageView * fourthImage = [self add_allFotterImageWithID:@"footerBg_04"];
        UIImageView * fourthImage = [[UIImageView alloc]init];
        [fourthImage sd_setImageWithURL:[self getImageURLWithImageString:@"footerBg_04"]];
        [self addSubview:fourthImage];
        [fourthImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(thirdImage.mas_bottom);
            make.left.right.equalTo(self);
            make.height.equalTo(@190);
        }];
    }
    return self;
}

- (NSURL *)getImageURLWithImageString:(NSString *)string {
    NSString *url = [NSString stringWithFormat:@"https://m.hfhomes.cn/images/vip/%@.jpg",string];
    return [NSURL URLWithString:url];
}
- (UIImageView *)add_allFotterImageWithID:(NSString *)idString {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:idString ofType:@"jpg"];
    UIImage * image = [UIImage imageWithContentsOfFile:filePath];;
    UIImageView *bgView = [[UIImageView alloc]initWithImage:image];
    bgView.userInteractionEnabled = YES;
    return bgView;
}
@end
