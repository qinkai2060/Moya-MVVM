//
//  CategoryHeaderCollectionView.m
//  housebank
//
//  Created by liqianhong on 2018/10/25.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpTypesHeaderCollectionView.h"

@interface SpTypesHeaderCollectionView ()

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *moreLab;
@property (nonatomic, strong) UIImageView *moreImageView;

@end

@implementation SpTypesHeaderCollectionView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView{
    //
    self.titleLab =[[UILabel alloc] initWithFrame:CGRectMake(15, 40, 200, 20)];
    self.titleLab.textColor = RGBACOLOR(51, 51, 51, 1);
    self.titleLab.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:self.titleLab];
    
    //
    self.moreLab = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 25 - 80, self.titleLab.frame.origin.y, 80, self.titleLab.frame.size.height)];
    self.moreLab.textAlignment = NSTextAlignmentRight;
    self.moreLab.textColor = RGBACOLOR(102, 102, 102, 1);
    self.moreLab.font = [UIFont systemFontOfSize:12.0];
    self.moreLab.text = @"更多";
    [self addSubview:self.moreLab];
    
    //
    self.moreImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.moreLab.frame), self.moreLab.frame.origin.y + 2.5, 15, 15)];
    self.moreImageView.userInteractionEnabled = YES;
    self.moreImageView.image = [UIImage imageNamed:@"SpTypes_group"];
    [self addSubview:self.moreImageView];
    
    //
    self.moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.moreBtn.frame = CGRectMake(self.moreLab.frame.origin.x, self.moreLab.frame.origin.y, 105, self.moreLab.frame.size.height);
    self.moreBtn.backgroundColor = [UIColor clearColor];
//    [self.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreBtn];
}

- (void)refreshHeaderViewWithModel:(SpTypeFirstLevelModel *)model{
    self.titleLab.text = model.classifyName;
}

// 更多按钮的点击事件
- (void)moreBtnClick:(UIButton *)btn{
//    if ([self.delegate respondsToSelector:@selector(headerViewMoreBtnClick:)]) {
//        [self.delegate headerViewMoreBtnClick:btn];
//    }
}

@end
