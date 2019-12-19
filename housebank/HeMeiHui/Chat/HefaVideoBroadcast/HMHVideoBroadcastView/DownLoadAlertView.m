//
//  HMHDownLoadAlertView.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/7/20.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "DownLoadAlertView.h"
@interface DownLoadAlertView ()
@property (nonatomic, assign) BOOL isDownLoading;

@end

@implementation DownLoadAlertView

-(instancetype)initWithImageName:(NSString *)imageName title:(NSString *)titleStr describeStr:(NSString *)describeStr isLoading:(BOOL)isLoading{
    self=[super init];
    if (self) {
        self.isDownLoading = isLoading;
        if (isLoading) {
            [self createDownLoadingAlertViewWithImageName:imageName title:titleStr];
        } else {
            [self createDownLoadStateAlertViewWithImageName:imageName title:titleStr describeStr:describeStr];
        }
    }
    return self;
}
// 下载中
- (void)createDownLoadingAlertViewWithImageName:(NSString *)imageName title:(NSString *)titleStr{
    self.frame=[UIScreen mainScreen].bounds;
    
    UIView *bgView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor=[UIColor blackColor];
    bgView.alpha=0.6;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(ScreenW / 5.0 - 20, (ScreenH-ScreenW / 5.0 / 2.0 - 30)/2.0 - 50, ScreenW / 5.0 * 3.0 + 40, ScreenW / 5.0 + 30)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius=10;
    [self addSubview:bgView];
    [self addSubview:view];
    
    //
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(view.frame.size.width - 25, 5, 20, 20);
    [cancelBtn setImage:[UIImage imageNamed:@"downLoadImageCancel"] forState:UIControlStateNormal];
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.cornerRadius = 10.0;
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    
    //
    UIActivityIndicatorView *centerImage = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2 - 20, 15, 35, 35)];
    self.centerImage = centerImage;
    [view addSubview:centerImage];
    centerImage.alpha = 1.0;
    [centerImage setColor:[UIColor blueColor]];


    UILabel *titile=[[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height / 2 + 10, view.frame.size.width, 20)];
    self.titile =titile;
    titile.font=[UIFont systemFontOfSize:16];
    titile.textAlignment=NSTextAlignmentCenter;
    [view addSubview:titile];
    
}
// 取消按钮点击
- (void)cancelBtnClick:(UIButton *)btn{
    if (self.downLoadCancelBtnClick) {
        self.downLoadCancelBtnClick();
    }
    
//    [self removeFromSuperview];
}

// 下载状态 成功 失败
- (void)createDownLoadStateAlertViewWithImageName:(NSString *)imageName title:(NSString *)titleStr describeStr:(NSString *)describeStr{
    self.frame=[UIScreen mainScreen].bounds;
    
    UIView *bgView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor=[UIColor blackColor];
    bgView.alpha=0.6;
    
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(ScreenW / 5.0 - 20, (ScreenH-ScreenW / 5.0 / 2.0 - 30)/2.0 - 50, ScreenW / 5.0 * 3.0 + 40, ScreenW / 5.0 + 30)];
    view.backgroundColor=[UIColor whiteColor];
    view.layer.masksToBounds=YES;
    view.layer.cornerRadius=10;
    [self addSubview:bgView];
    [self addSubview:view];
    
    //    UIActivityIndicatorView *centerImage = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2 - 10, 15, 20, 20)];
    //    self.centerImage = centerImage;
    //    centerImage.backgroundColor = [UIColor redColor];
    //    [view addSubview:centerImage];
    //    centerImage.alpha = 1.0;
    //    [centerImage setColor:[UIColor redColor]];
    
    
    UIImageView *centerImage = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width / 2 - 10, 15, 20, 20)];
    centerImage.image = [UIImage imageNamed:imageName];
    [view addSubview:centerImage];
    //
    UILabel *titile=[[UILabel alloc]initWithFrame:CGRectMake(0, view.frame.size.height / 2 - 10, view.frame.size.width, 20)];
    titile.font=[UIFont systemFontOfSize:18];
    titile.textColor=[UIColor colorWithHexString:@"333333"];
    if (titleStr==nil) {
        titile.frame= CGRectMake(0, 10, 0, 0);
    }else{
        titile.text=titleStr;
    }
    titile.textAlignment=NSTextAlignmentCenter;
    [view addSubview:titile];
    
    //
    UILabel *desLab = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titile.frame) , view.frame.size.width, 20)];
    desLab.font = [UIFont systemFontOfSize:12.0];
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.textColor = RGBACOLOR(132, 133, 134, 1);
    desLab.text = describeStr;
    [view addSubview:desLab];
}


-(void)show{
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    if (self.isDownLoading) {
        [self.centerImage startAnimating];
    } else {
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(dismissDownLoadAlertView:)
                                       userInfo:self
                                        repeats:NO];
    }

}

-(void)dismissDownLoadAlertView:(NSTimer*)timer{
    if (timer.userInfo) {
        [timer.userInfo removeFromSuperview];
    }
    [timer invalidate];
    timer = nil;
}


@end
