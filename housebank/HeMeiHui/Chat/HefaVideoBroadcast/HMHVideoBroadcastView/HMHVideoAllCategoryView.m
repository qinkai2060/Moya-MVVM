//
//  HMHVideoAllCategoryView.m
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/18.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "HMHVideoAllCategoryView.h"
#import "HMHVideoCategoryParentModel.h"

@interface HMHVideoAllCategoryView ()

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation HMHVideoAllCategoryView
- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)dataSource{
    self = [super initWithFrame:frame];
    if (self) {
        _dataSourceArr = [NSMutableArray arrayWithCapacity:1];
        _dataSourceArr = dataSource;
        [self createUI];
    }
    return self;
}
- (void)createUI{
    //
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.frame.size.height)];
    whiteView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteView];
    
    //
    UILabel *allLab = [[UILabel alloc] initWithFrame:CGRectMake(10,0, ScreenW - 20, 40 - 1)];
    allLab.font = [UIFont systemFontOfSize:16.0];
    allLab.textColor = RGBACOLOR(70, 76, 78, 1);
    allLab.text = @"全部分类";
    [whiteView addSubview:allLab];
    
    //
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0,39,ScreenW, 1)];
    lineLab.backgroundColor = RGBACOLOR(234, 235, 236, 1);
    [whiteView addSubview:lineLab];
    
    CGFloat space = 0;
    int m = 3;//单行列
    CGFloat imgvW = ScreenW / 3;
    
    for (int i=0; i<_dataSourceArr.count; i++) {
        HMHVideoCategoryParentModel *pModel = _dataSourceArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((imgvW+space)*(i%m),40 + (40 +space)*(i/m), imgvW,40);
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitle:pModel.name forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [btn setTitleColor:RGBACOLOR(139, 140, 142, 1) forState:UIControlStateNormal];
        btn.tag = 19000+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView addSubview:btn];
        //
        UILabel *bottomLab = [[UILabel alloc] initWithFrame:CGRectMake(0, btn.frame.size.height - 1, btn.frame.size.width, 1)];
        bottomLab.backgroundColor = RGBACOLOR(234, 235, 236, 1);
        [btn addSubview:bottomLab];
        //
        UILabel *rightLab = [[UILabel alloc] initWithFrame:CGRectMake(btn.frame.size.width - 1, 0, 1, btn.frame.size.height)];
        rightLab.backgroundColor = RGBACOLOR(234, 235, 236, 1);
        [btn addSubview:rightLab];
    }
}

//中间可变行数高度
+(CGFloat)getCategoryViewHeightWithArr:(NSMutableArray *)arr
{
    //View的高度
    CGFloat content_H=0.0;
    CGFloat space = 0;
    int m = 3;//单行列
    if (arr.count > 0 && arr.count <=m){ // 一行 ,40 + (40 +space)*(i/m)
        content_H = 40 + 40;
    } else if(arr.count > m){
        CGFloat imgvW = 40;
        //行数
        NSInteger lineCount = arr.count/m;
        if (arr.count % m) {
            lineCount = lineCount + 1;
        }
        content_H = 40 + imgvW*lineCount+space*(lineCount-1);
    }
    
    return content_H;
}


- (void)btnClick:(UIButton *)btn{
    if (self.allcategoryBlock) {
        self.allcategoryBlock(btn.tag - 19000);
    }
}


@end
