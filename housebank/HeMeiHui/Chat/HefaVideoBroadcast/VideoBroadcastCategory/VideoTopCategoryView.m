//
//  VideoTopCategoyView.m
//  ihefaTestUI
//
//  Created by Qianhong Li on 2018/4/13.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "VideoTopCategoryView.h"
#import "UIButton+setTitle_Image.h"
#import "HMHVideoHomeModuleMenuModel.h"

@interface VideoTopCategoryView ()

@property (nonatomic, strong) NSMutableArray *dataSourceArr;

@end

@implementation VideoTopCategoryView

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)dataSource{
    self = [super initWithFrame:frame];
    if (self) {
        _dataSourceArr = dataSource;
        [self createUI];
    }
    return self;
}

- (void)createUI{
    CGFloat space = 5;
    int m = 4;//单行列
    CGFloat imgvW = (ScreenW-20-space*(m-1))/m;
    for (int i=0; i<_dataSourceArr.count; i++) {
        
        HMHVideoHomeModuleMenuModel *model = _dataSourceArr[i];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+(imgvW+space)*(i%m), (imgvW / 4 * 3 +space)*(i/m), imgvW / 2, imgvW / 2)];
        imageView.userInteractionEnabled = YES;
        NSString *str1 = [model.imagePath substringToIndex:4];//截取掉下标5之前的字符串
        if ([str1 isEqualToString:@"http"]) { // 网络图片
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.imagePath] placeholderImage:[UIImage imageNamed:@"circle_default_loading_error"]];
        } else { // 本地图片
            NSArray *array = [model.imagePath componentsSeparatedByString:@"."];
            if (array.count > 1) {
                NSString *str2 = array[0];
                imageView.image = [UIImage imageNamed:str2];
            }
        }
        
        [self addSubview:imageView];
        
        UILabel *textLab = [[UILabel alloc] initWithFrame:CGRectMake(10+(imgvW+space)*(i%m), CGRectGetMaxY(imageView.frame), imgvW, 20)];
        textLab.text = model.text;
        textLab.font = [UIFont systemFontOfSize:14.0];
        textLab.textAlignment = NSTextAlignmentCenter;
        textLab.textColor = RGBACOLOR(139, 140, 142, 1);
        [self addSubview:textLab];
        
        imageView.center = textLab.center;
        CGRect rect = imageView.frame;
        rect.origin.y = (imgvW / 4 * 3 +space)*(i/m);
        imageView.frame = rect;

        //
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10+(imgvW+space)*(i%m),(imgvW / 4 * 3 +space)*(i/m), imgvW, imgvW / 4 * 3);
        btn.tag = 1000+i;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }
    
}

//中间可变行数高度
+(CGFloat)getCenterViewHeightWithArr:(NSMutableArray *)arr
{
    //View的高度
    CGFloat content_H=0.0;
    CGFloat space = 5;
    int m = 4;//单行列
    if (arr.count > 0 && arr.count <=4){ // 一行
        content_H = (ScreenW-20-space*(m-1))/m / 4 * 3;
    } else if(arr.count > 4){
        CGFloat imgvW = (ScreenW-20-space*(m-1))/m / 4 *3;
        //行数
        NSInteger lineCount = arr.count/4;
        if (arr.count % 4) {
            lineCount = lineCount + 1;
        }
        content_H = imgvW*lineCount+space*(lineCount-1);
    }
    
    return content_H + 5;
}
// 按钮的点击事件
- (void)btnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(videoCategoryBtnClickToInfoWithIndex:)]) {
        [self.delegate videoCategoryBtnClickToInfoWithIndex:btn.tag];
    }
}

@end
