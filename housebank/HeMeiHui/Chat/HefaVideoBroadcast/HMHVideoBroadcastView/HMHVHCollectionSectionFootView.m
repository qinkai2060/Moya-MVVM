//
//  CollectionSectionFootView.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVHCollectionSectionFootView.h"
@interface HMHVHCollectionSectionFootView ()
{
    UILabel *HMH_titleLab;
}
@end

@implementation HMHVHCollectionSectionFootView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    footView.backgroundColor = RGBACOLOR(241, 242, 244, 1);
    [self addSubview:footView];
    //
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 1)];
    lineLab.backgroundColor = RGBACOLOR(241, 242, 244, 1);
    [footView addSubview:lineLab];
    
    //
    HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, ScreenW, 40)];
    HMH_titleLab.font = [UIFont systemFontOfSize:12.0];
    HMH_titleLab.textColor = RGBACOLOR(85, 86, 86, 1);
    HMH_titleLab.backgroundColor = [UIColor whiteColor];
    HMH_titleLab.text = self.bottomStr;
    HMH_titleLab.textAlignment = NSTextAlignmentCenter;
    [footView addSubview:HMH_titleLab];

    //
    UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allBtn.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    allBtn.backgroundColor = [UIColor clearColor];
    [allBtn addTarget:self action:@selector(allBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:allBtn];
}

-(void)refreshTitle:(NSString *)titleStr{
    HMH_titleLab.text = titleStr;
}

- (void)allBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(bottomToSeeAllVideoBtnClickWithSection:)]) {
        [self.delegate bottomToSeeAllVideoBtnClickWithSection:self.sectionIndex];
    }
}

@end
