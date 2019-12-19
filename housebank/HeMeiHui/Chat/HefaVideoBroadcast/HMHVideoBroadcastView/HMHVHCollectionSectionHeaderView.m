//
//  CollectionSectionHeaderView.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVHCollectionSectionHeaderView.h"

@interface HMHVHCollectionSectionHeaderView ()

@end

@implementation HMHVHCollectionSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    //
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0,0, ScreenW, 45)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headerView];
    //
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 5,ScreenW, 40)];
    _titleLab.font = [UIFont systemFontOfSize:18.0];
    _titleLab.textColor = RGBACOLOR(41, 42, 42, 1);
    _titleLab.text = @"编辑·精选";
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:_titleLab];

}

@end
