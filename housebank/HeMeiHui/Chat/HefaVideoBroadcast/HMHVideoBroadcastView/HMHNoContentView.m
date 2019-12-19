//
//  HMHNoContentView.m
//  MCF2
//
//  Created by zhangkai on 16/5/18.
//  Copyright © 2016年 ac. All rights reserved.
//

#import "HMHNoContentView.h"

@implementation HMHNoContentView
{
    UIImageView *HMH_imgv;
    UILabel *HMH_lab;
    UILabel *HMH_subLab;
    UIButton *refreshBtn;
}

- (instancetype)initWithImg:(UIImage *)img title:(NSString *)title subTitle:(NSString *)subTitle{
    self = [super initWithFrame:CGRectMake(0, 0, img.size.width+20, img.size.height+20)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        HMH_imgv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, img.size.width, img.size.height)];
        HMH_imgv.backgroundColor = [UIColor clearColor];
        HMH_imgv.image = img;
        [self addSubview:HMH_imgv];
        
        HMH_lab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(HMH_imgv.frame) + 15, self.frame.size.width, 20)];
        HMH_lab.backgroundColor = [UIColor clearColor];
        HMH_lab.textAlignment = NSTextAlignmentCenter;
        HMH_lab.font = [UIFont systemFontOfSize:16.0];
        HMH_lab.textColor = RGBACOLOR(151, 147, 150, 1);
        HMH_lab.text = title;
        [self addSubview:HMH_lab];
        
        HMH_subLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(HMH_lab.frame) + 10, self.frame.size.width, 20)];
        HMH_subLab.backgroundColor = [UIColor clearColor];
        HMH_subLab.textAlignment = NSTextAlignmentCenter;
        HMH_subLab.font = [UIFont systemFontOfSize:14.0];
        HMH_subLab.textColor = RGBACOLOR(163, 163, 163, 1);
        HMH_subLab.text = subTitle;
        [self addSubview:HMH_subLab];

    }
    return self;
}

-(void)setImg:(UIImage *)img{
    HMH_imgv.image = img;
}

-(void)setTitle:(NSString *)title{
    HMH_lab.text = title;
}

- (void)setSubTitle:(NSString *)subTitle{
    HMH_subLab.text = subTitle;
}

-(void)setFont:(UIFont *)font{
    HMH_lab.font = font;
}

@end
