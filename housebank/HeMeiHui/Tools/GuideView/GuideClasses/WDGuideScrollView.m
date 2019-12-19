//
//  WDGuideScrollView.m
//  功能引导页
//
//  Created by Chen on 15/6/8.
//  Copyright (c) 2015年 chenweidong. All rights reserved.
//

#import "WDGuideScrollView.h"
#import "UIImage+Color.h"
#import <POP.h>
#import "DrawCircleProgressButton.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"
@interface WDGuideScrollView ()<UIScrollViewDelegate,POPAnimationDelegate>
@property (nonatomic, strong) UIScrollView  *guideScrollView;
@property (nonatomic, strong) UIPageControl *imagePageControl;
@property (nonatomic, strong) NSMutableArray *views;
@property (nonatomic,assign) NSInteger time;
@property (nonatomic,assign)NSTimer *myTimer;
@property (nonatomic,assign)NSInteger adIamgCount;

@end

@implementation WDGuideScrollView

- (void)scrollViewWithImageArray:(NSArray *)imageArray
{
    _adIamgCount=imageArray.count;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        UIImage *image  = [UIImage imageWithContentsOfFile:[imageArray objectAtIndex:i]];
        imageView.image = image;
        if (i == imageArray.count - 1) {
            imageView.userInteractionEnabled = YES;
            DrawCircleProgressButton *drawCircleView;
            
            if (IS_iPhoneX){
                drawCircleView = [[DrawCircleProgressButton alloc]initWithFrame:CGRectMake(imageView.frame.size.width - 55, 44 + 10, 40, 40)];
            } else {
                drawCircleView = [[DrawCircleProgressButton alloc]initWithFrame:CGRectMake(imageView.frame.size.width - 55, 20 + 10, 40, 40)];
            }
            
            [drawCircleView setTitle:@"跳过" forState:UIControlStateNormal];
            [drawCircleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            drawCircleView.titleLabel.font = [UIFont systemFontOfSize:14];
            [drawCircleView addTarget:self action:@selector(removeProgress) forControlEvents:UIControlEventTouchUpInside];
            __weak id weakSelf = self;
            if (imageArray.count<2) {
                drawCircleView.lineWidth = 2.f;
                [drawCircleView start];
                [drawCircleView startAnimationDuration:3 withBlock:^{
                    [weakSelf removeProgress];
                }];
            }else{
                drawCircleView.trackColor =  [UIColor clearColor];
                drawCircleView.fillColor = [UIColor clearColor];
                drawCircleView.backGroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.3];
                drawCircleView.lineWidth = 0.f;
                drawCircleView.layer.masksToBounds = YES;
                drawCircleView.layer.cornerRadius  = drawCircleView.frame.size.width/2;
                [drawCircleView start];
            }
            
            [imageView addSubview:drawCircleView];
        }
        imageView.tag = 101+i;
        [imageView setClickListener:self action:@selector(UIImgaeViewClick:) forEvent:UIGestureRecognizerTypeClick];

        [self.guideScrollView addSubview:imageView];
    }
    self.guideScrollView.contentSize = CGSizeMake((imageArray.count) * ScreenWidth, 0);
    //系统自带的点太小，自定义下面的点
    if (imageArray.count>1) {
        [self updateCount:(int)imageArray.count pointWidth :15 height:12 width:12];
        self.imagePageControl.numberOfPages = imageArray.count;
    }
  
}

- (void)removeProgress
{

    self.transform = CGAffineTransformMakeScale(1, 1);
    self.alpha = 1;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.1;
        self.transform = CGAffineTransformMakeScale(3, 3);
    } completion:^(BOOL finished) {
        
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        window.windowLevel = UIWindowLevelNormal;
        [self removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadingHome" object:nil];
    }];
    
}
- (UIScrollView *)guideScrollView
{
    if (_guideScrollView == nil) {
        _guideScrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        _guideScrollView.backgroundColor = [UIColor clearColor];
        _guideScrollView.pagingEnabled = YES;
        _guideScrollView.bounces = NO;
        _guideScrollView.delegate = self;
        _guideScrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            /** iOS11 UIScrollView顶到屏幕顶端会出现一个20高度的白色间隔，是由于UIScrollView的自动调整功能为状态栏留出的位置 */
            _guideScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_guideScrollView setClickListener:self action:@selector(UIImgaeViewClick:) forEvent:UIGestureRecognizerTypeClick];
        [self addSubview:_guideScrollView];
    }
    return _guideScrollView;
}

- (void)UIImgaeViewClick:(UIGestureRecognizer*)ges{
    if ([self.deledate respondsToSelector:@selector(ClickUIImageViewOnIndex:)]) {
        
        NSInteger num = ges.view.tag-101;
        
        [self.deledate ClickUIImageViewOnIndex:num];
        [self removeProgress];

//        if (num==_adIamgCount-1) {
//
//            [self removeProgress];
//            
//        }
    }

}

#pragma mark ScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = (self.guideScrollView.contentOffset.x + scrollView.frame.size.width / 2) / ScreenWidth;
    //    self.imagePageControl.currentPage = page;
    [self selectedWithIndex:page];
}

//设置下方圆点位置
- (void)updateCount:(int)count
         pointWidth:(float)pointWidth
             height:(float)height
              width:(float)width{
    float itemX = (ScreenWidth - (count - 1) * pointWidth - count*width)*0.5;
    self.views = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        UIImageView * pointView = [[UIImageView alloc]initWithFrame:CGRectMake(itemX + i*(width + pointWidth) , ScreenHeight == 480?ScreenHeight - 14 - height:ScreenHeight - 36 - height, width, height)];
        pointView.layer.masksToBounds = YES;
        pointView.layer.cornerRadius = pointView.frame.size.width/2;
        pointView.image = [UIImage imageWithSolidColor:RGB(171, 171, 171) size:pointView.frame.size];
        pointView.highlightedImage = [UIImage imageWithSolidColor:RGB(106, 226, 226) size:pointView.frame.size];
        [self.views addObject:pointView];
        [self addSubview:pointView];
        if (i == 0) {
            pointView.highlighted = YES;
        }
    }
}

- (void)selectedWithIndex:(int)index
{
    for (UIImageView *v in self.views) {
        v.highlighted = NO;
    }
    UIImageView *view = [self.views objectAtIndex:index];
    view.highlighted = YES;
}

- (void)dealloc{

    NSLog(@"当前页面销毁");
}
@end
