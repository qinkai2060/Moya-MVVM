//
//  HMHVideoPlayBottomView.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/4.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "HMHVideoPlayBottomView.h"

@interface HMHVideoPlayBottomView ()

@property (nonatomic, strong) UIView *HMH_videoBottomView;
@property (nonatomic, strong) UILabel *HMH_looksNumLab;
@property (nonatomic, strong) UIButton *HMH_lab1; // 标签1 合发培训
@property (nonatomic, strong) UIButton *HMH_lab2; // 标签2  企业文化
@property (nonatomic, strong) UIButton *HMH_downloadBtn; // 下载按钮

@end

@implementation HMHVideoPlayBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self HMH_createUI];
    }
    return self;
}

- (void)HMH_createUI{
    //
    _HMH_videoBottomView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, 30)];
    _HMH_videoBottomView.backgroundColor = [UIColor blackColor];
    [self addSubview:_HMH_videoBottomView];
    
    //
    self.HMH_looksNumLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, 30)];
    self.HMH_looksNumLab.font = [UIFont systemFontOfSize:12.0];
    self.HMH_looksNumLab.textColor = RGBACOLOR(124, 125, 127, 1);
    [self.HMH_videoBottomView addSubview:self.HMH_looksNumLab];
    
    //
    self.HMH_downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_downloadBtn.frame = CGRectMake(self.HMH_videoBottomView.frame.size.width - 40 - 30, 0, 30, 30);
//    canDownload
    [self.HMH_downloadBtn setImage:[UIImage imageNamed:@"Video_downloadImage"] forState:UIControlStateNormal];
    self.HMH_downloadBtn.hidden = YES;
    [self.HMH_downloadBtn addTarget:self action:@selector(downloadVideoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.HMH_videoBottomView addSubview:self.HMH_downloadBtn];
    
    //
    self.HMH_lab1 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_lab1.frame =CGRectMake(self.HMH_videoBottomView.frame.size.width - 45 - 60,15 / 2,60, 15);
    self.HMH_lab1.backgroundColor = RGBACOLOR(163, 125, 58, 1);
    self.HMH_lab1.backgroundColor = [UIColor colorWithHexString:@"#4D88FF"];
    [self.HMH_lab1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.HMH_lab1.titleLabel.font = [UIFont systemFontOfSize:10.0];
//    self.HMH_lab1.textAlignment = NSTextAlignmentCenter;
    self.HMH_lab1.layer.masksToBounds = YES;
    self.HMH_lab1.layer.cornerRadius = 2;
    [self.HMH_lab1 addTarget:self action:@selector(lab1BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.HMH_lab1.hidden = YES;
    [self.HMH_videoBottomView addSubview:self.HMH_lab1];
    
    //
    self.HMH_lab2 = [UIButton buttonWithType:UIButtonTypeCustom];
    self.HMH_lab2.frame = CGRectMake(CGRectGetMidX(self.HMH_lab1.frame) - 10 - 30  - 60, self.HMH_lab1.frame.origin.y, 60, 15);
    self.HMH_lab2.backgroundColor = RGBACOLOR(163, 125, 58, 1);
    self.HMH_lab2.backgroundColor = [UIColor colorWithHexString:@"#4D88FF"];
    [self.HMH_lab2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.HMH_lab2.titleLabel.font = [UIFont systemFontOfSize:10.0];
    self.HMH_lab2.layer.masksToBounds = YES;
    self.HMH_lab2.layer.cornerRadius = 2;
    [self.HMH_lab2 addTarget:self action:@selector(lab2BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.HMH_lab2.hidden = YES;
    [self.HMH_videoBottomView addSubview:self.HMH_lab2];
    
    //
    self.shouCangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shouCangBtn.frame = CGRectMake(self.HMH_videoBottomView.frame.size.width - 40, 0, 30, 30);
    [self.shouCangBtn setImage:[UIImage imageNamed:@"VP_shouCangImage"] forState:UIControlStateNormal];
    [self.shouCangBtn setImage:[UIImage imageNamed:@"VP_YishouCang1"] forState:UIControlStateSelected];
    [self.shouCangBtn addTarget:self action:@selector(shoucangBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.HMH_videoBottomView addSubview:self.shouCangBtn];
}

- (void)refreshPlayerBottomViewWithModel:(HMHVideoListModel *)model isFromTimeLive:(BOOL)isFromTimeLive{
    // 当数据返回时 才显示这两个标签
    self.HMH_lab1.hidden = NO;
    self.HMH_lab2.hidden = NO;
    
    if (model.favorite) {
        self.shouCangBtn.selected = YES;
    } else {
        self.shouCangBtn.selected = NO;
    }
    
    NSString *hitsStr;
    if ([model.hits integerValue] > 10000) {
        float hitsF = [model.hits floatValue] / 10000.0;
        hitsStr = [NSString stringWithFormat:@"%.1f万人观看",hitsF];
    } else {
        int hitsI = [model.hits intValue];
        hitsStr = [NSString stringWithFormat:@"%d人观看",hitsI];
    }
    self.HMH_looksNumLab.text = hitsStr;
    
    //
    NSString *lab1Str;
    if (model.videoTagName.length > 0) {
        NSArray *arr = [model.videoTagName componentsSeparatedByString:@","];
        if (arr.count >0) {
            lab1Str = [arr objectAtIndex:0];
        }
    }
    [self.HMH_lab1 setTitle:lab1Str forState:UIControlStateNormal];
    
    CGSize size = [lab1Str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10.0],NSFontAttributeName, nil]];
    
    CGRect rect1 = self.HMH_lab1.frame;

    //
    NSString *lab2Str = [NSString stringWithFormat:@"%@",model.primaryCategoryName];

    [self.HMH_lab2 setTitle:lab2Str forState:UIControlStateNormal];
    CGSize secondSize = [lab2Str sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:10.0],NSFontAttributeName, nil]];
    CGRect rect2 = self.HMH_lab2.frame;
    
    if (isFromTimeLive) { // 如果是来自直播
        self.HMH_downloadBtn.hidden = YES;
        rect1.origin.x = self.HMH_videoBottomView.frame.size.width - size.width - 50 - 10;
        rect1.size.width = size.width + 10;
        self.HMH_lab1.frame = rect1;
        
        rect2.origin.x = CGRectGetMidX(self.HMH_lab1.frame) - secondSize.width  - 30 - 10;
        rect2.size.width = secondSize.width + 10;
        self.HMH_lab2.frame = rect2;
        if (lab2Str.length > 0 && ![lab2Str isEqualToString:@"(null)"]) {
            self.HMH_lab2.hidden = NO;
            self.HMH_lab2.width = secondSize.width + 10;
        } else {
            self.HMH_lab2.hidden = YES;
        }
        
        if (lab1Str.length > 0) {
            self.HMH_lab1.hidden = NO;
            self.HMH_lab1.width = size.width + 10;
        } else {
            self.HMH_lab1.hidden = YES;
            rect2.origin.x = self.HMH_videoBottomView.frame.size.width - secondSize.width - 50;
            self.HMH_lab2.frame = rect2;
        }

    } else { // 短视频和回放
        if (model.canDownload) {
            self.HMH_downloadBtn.hidden = NO;
            rect1.origin.x = self.HMH_videoBottomView.frame.size.width - size.width - 50 - 40;
            rect1.size.width = size.width + 10;
            self.HMH_lab1.frame = rect1;
            
            rect2.origin.x = CGRectGetMidX(self.HMH_lab1.frame) - secondSize.width  - 30 - 40;
            rect2.size.width = secondSize.width + 10;
            self.HMH_lab2.frame = rect2;
            if (lab2Str.length > 0 && ![lab2Str isEqualToString:@"(null)"]) {
                self.HMH_lab2.hidden = NO;
                self.HMH_lab2.width = secondSize.width + 10;
            } else {
                self.HMH_lab2.hidden = YES;
            }
            
            if (lab1Str.length > 0) {
                self.HMH_lab1.hidden = NO;
                self.HMH_lab1.width = size.width + 10;
            } else {
                self.HMH_lab1.hidden = YES;
                rect2.origin.x = self.HMH_videoBottomView.frame.size.width - secondSize.width - 50 - 40;
                self.HMH_lab2.frame = rect2;
            }
            
        } else {
            self.HMH_downloadBtn.hidden = YES;
            rect1.origin.x = self.HMH_videoBottomView.frame.size.width - size.width - 50 - 10;
            rect1.size.width = size.width + 10;
            self.HMH_lab1.frame = rect1;
            
            rect2.origin.x = CGRectGetMidX(self.HMH_lab1.frame) - secondSize.width  - 30 - 10;
            rect2.size.width = secondSize.width + 10;
            self.HMH_lab2.frame = rect2;
            if (lab2Str.length > 0 && ![lab2Str isEqualToString:@"(null)"]) {
                self.HMH_lab2.hidden = NO;
                self.HMH_lab2.width = secondSize.width + 10;
            } else {
                self.HMH_lab2.hidden = YES;
            }
            
            if (lab1Str.length > 0) {
                self.HMH_lab1.hidden = NO;
                self.HMH_lab1.width = size.width + 10;
            } else {
                self.HMH_lab1.hidden = YES;
                rect2.origin.x = self.HMH_videoBottomView.frame.size.width - secondSize.width - 50;
                self.HMH_lab2.frame = rect2;
            }
        }
    }
}

- (void)shoucangBtnClick:(UIButton *)btn{
    NSInteger states;
    if (btn.selected) { // 收藏
        states = 1;
    } else {
        states = 2;
    }

    if (self.shouCangBtnClick) {
        self.shouCangBtnClick(states);
    }
  //  btn.selected = !btn.selected;
}
// 下载按钮的点击事件
-(void)downloadVideoBtnClick:(UIButton *)btn{
    if (self.downloadBtnClick) {
        self.downloadBtnClick();
    }
}

// 第一个标签的点击事件
- (void)lab1BtnClick:(UIButton *)btn{
    NSLog(@"第一个标签的点击事件");
}
// 第二个标签按钮的点击事件
- (void)lab2BtnClick:(UIButton *)btn{
    NSLog(@"第二个标签的点击事件");
}

@end
