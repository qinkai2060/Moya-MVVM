//
//  hefaCategoryView.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/18.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoCategoryView.h"

@interface HMHVideoCategoryView ()

@property (nonatomic, strong) UIImageView *HMH_bgImageView;
@property (nonatomic, strong) UIImageView *HMH_centerImageView;
@property (nonatomic, strong) UILabel *HMH_titleLab;

@property (nonatomic, strong) HMHVideoCategoryParentModel *pModel;
@property (nonatomic, strong) NSMutableArray *childArr;

@property (nonatomic, assign) NSInteger sectionIndex;
@end

@implementation HMHVideoCategoryView

- (instancetype)initWithFrame:(CGRect)frame withSection:(NSInteger)indexPathSection parentModel:(HMHVideoCategoryParentModel *)pModel{
    self = [super initWithFrame:frame];
    if (self) {
        _childArr = [NSMutableArray arrayWithCapacity:1];
        _pModel = [[HMHVideoCategoryParentModel alloc] init];
        
        _pModel = pModel;
        _sectionIndex = indexPathSection;
                
        [self createUI];
    }
    return self;
}
- (void)createUI{
    //
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 120)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    //
    self.HMH_bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, 120)];
    self.HMH_bgImageView.userInteractionEnabled = YES;
    [whiteView addSubview:self.HMH_bgImageView];
    
    if (_sectionIndex % 2 == 0) {
        self.HMH_bgImageView.image = [UIImage imageNamed:@"video_categoryOne"];
    } else {
        self.HMH_bgImageView.image = [UIImage imageNamed:@"video_categoryTwo"];
    }
    
    //
    self.HMH_centerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.HMH_bgImageView.frame.size.width/ 2 - 10, self.HMH_bgImageView.frame.size.height / 2 - 10 - 5, 20, 20)];
    self.HMH_centerImageView.backgroundColor = [UIColor redColor];
//    [self.HMH_bgImageView addSubview:self.HMH_centerImageView];
    
    //
    self.HMH_titleLab = [[UILabel alloc] initWithFrame:CGRectMake(5, self.HMH_bgImageView.frame.size.height / 2 - 10, self.HMH_bgImageView.frame.size.width - 10, 20)];
    self.HMH_titleLab.font = [UIFont systemFontOfSize:16.0];
    self.HMH_titleLab.textColor = RGBACOLOR(70, 76, 78, 1);
    self.HMH_titleLab.textAlignment = NSTextAlignmentCenter;
    self.HMH_titleLab.text = _pModel.name;
    [self.HMH_bgImageView addSubview:self.HMH_titleLab];
    
    //
    UIButton *bgImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgImageBtn.frame = CGRectMake(0, 0, self.HMH_bgImageView.frame.size.width, self.HMH_bgImageView.frame.size.height);
    bgImageBtn.backgroundColor = [UIColor clearColor];
    [bgImageBtn addTarget:self action:@selector(bgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.HMH_bgImageView addSubview:bgImageBtn];
    
    //
    for (int i = 0; i < _pModel.children.count; i++) {
        HMHVideoCategoryChildrenModel *cModel = _pModel.children[i];
        [_childArr addObject:cModel];
    }
    
    CGFloat space = 0;
    int m = 2;//单行列
    CGFloat imgvW = ScreenW / 3;

    // 限制最多为6个
    NSInteger numCount = 0;
    if (_childArr.count >6) {
        numCount = 6;
    } else {
        numCount = _childArr.count;
    }
    for (int i=0; i<numCount; i++) {
        NSDictionary *modelDic = _childArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(imgvW+(imgvW+space)*(i%m),(self.HMH_bgImageView.frame.size.height / 3 +space)*(i/m), imgvW,self.HMH_bgImageView.frame.size.height / 3);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:modelDic[@"name"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn setTitleColor:RGBACOLOR(139, 140, 142, 1) forState:UIControlStateNormal];
 
        btn.tag = 18000+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btn];
        
        UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.frame.size.height - 1, btn.frame.size.width, 1)];
        bottomLab.backgroundColor = RGBACOLOR(234, 235, 236, 1);
        [btn addSubview:bottomLab];
        
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width - 1, 0, 1, btn.frame.size.height)];
        rightLab.backgroundColor = RGBACOLOR(234, 235, 236, 1);
        [btn addSubview:rightLab];
    }
}

- (void)btnClick:(UIButton *)btn{
    if (self.categoryBlock) {
        self.categoryBlock(btn.tag - 18000);
    }
}

- (void)bgBtnClick:(UIButton *)btn{
    if (self.parentBlock) {
        self.parentBlock(@"parent");
    }
}

@end
