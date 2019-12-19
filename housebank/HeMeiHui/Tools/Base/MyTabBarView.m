//
//  MyTabBarView.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2017/11/17.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "MyTabBarView.h"
//#import "LoginViewController.h"
#import "AppDelegate.h"

//tabbar高度
#define TabBarViewHeight   49

#define kAppDelegate  (AppDelegate *)([UIApplication sharedApplication].delegate)

@implementation MyTabBarView

@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        self.currentIndex = -1;
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0.8)];
        line.backgroundColor = RGBACOLOR(217, 221, 226, 1.0);
        [self addSubview:line];
        
        mainHomeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        mainHomeBtn.frame=CGRectMake(0, 0, ScreenW/5, TabBarViewHeight);
        [mainHomeBtn setImage:[UIImage imageNamed:@"tab_main_home_on"] forState:UIControlStateNormal];
        [mainHomeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 16, 0)];
        mainHomeBtn.tag=101;
        [mainHomeBtn addTarget:self action:@selector(buttonChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mainHomeBtn];
        
        //导购园上小红点
//        _dgyRedLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dgyBtn.frame)-32, dgyBtn.frame.origin.y+7, 8, 8)];
//        _dgyRedLab.backgroundColor = [UIColor redColor];
//        _dgyRedLab.hidden = YES;
//        _dgyRedLab.layer.masksToBounds = YES;
//        _dgyRedLab.layer.cornerRadius = 4;
//        [self addSubview:_dgyRedLab];
        
        mainHomeLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, TabBarViewHeight - 21, ScreenW/5, 20)];
        mainHomeLabel.text=@"首页";
        mainHomeLabel.textAlignment=NSTextAlignmentCenter;
        mainHomeLabel.textColor=[UIColor blackColor];
        mainHomeLabel.font=[UIFont systemFontOfSize:11];
        [mainHomeBtn addSubview:mainHomeLabel];
        
        mainMallBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        mainMallBtn.frame=CGRectMake(ScreenW/5, 0, ScreenW/5, TabBarViewHeight);
        [mainMallBtn setImage:[UIImage imageNamed:@"tab_main_mall"] forState:UIControlStateNormal];
        [mainMallBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 16, 0)];
        mainMallBtn.tag=102;
        [mainMallBtn addTarget:self action:@selector(buttonChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mainMallBtn];
        
        mainMallLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, TabBarViewHeight - 21, ScreenW/5, 20)];
        mainMallLabel.text=@"商城";
        mainMallLabel.textAlignment=NSTextAlignmentCenter;
        mainMallLabel.font=[UIFont systemFontOfSize:11];
        [mainMallBtn addSubview:mainMallLabel];
        
        mainGlobalBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        mainGlobalBtn.frame=CGRectMake(ScreenW/5 * 2, 0, ScreenW/5, TabBarViewHeight);
        [mainGlobalBtn setImage:[UIImage imageNamed:@"tab_main_globalhome"] forState:UIControlStateNormal];
        [mainGlobalBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 16, 0)];
        mainGlobalBtn.tag=103;
        [mainGlobalBtn addTarget:self action:@selector(buttonChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mainGlobalBtn];
        
//        mainGlobalLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(chatBtn.frame)-32, chatBtn.frame.origin.y+7, 8, 8)];
//        _redLab.backgroundColor = [UIColor redColor];
//        _redLab.hidden = YES;
//        _redLab.layer.masksToBounds = YES;
//        _redLab.layer.cornerRadius = 4;
//        [self addSubview:_redLab];
        
        mainGlobalLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, TabBarViewHeight - 21, ScreenW/5, 20)];
        mainGlobalLabel.text=@"全球家";
        mainGlobalLabel.textAlignment=NSTextAlignmentCenter;
        mainGlobalLabel.font=[UIFont systemFontOfSize:11];
        [mainGlobalBtn addSubview:mainGlobalLabel];
        
        mainMomentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        mainMomentBtn.frame=CGRectMake(ScreenW-ScreenW/5 * 2, 0, ScreenW/5, TabBarViewHeight);
        [mainMomentBtn setImage:[UIImage imageNamed:@"tab_main_moments"] forState:UIControlStateNormal];
        [mainMomentBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 16, 0)];
        mainMomentBtn.tag=104;
        [mainMomentBtn addTarget:self action:@selector(buttonChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mainMomentBtn];
        
        mainMomentLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, TabBarViewHeight - 21, ScreenW/5, 20)];
        mainMomentLabel.text=@"合友圈";
        mainMomentLabel.textAlignment=NSTextAlignmentCenter;
        mainMomentLabel.font=[UIFont systemFontOfSize:11];
        [mainMomentBtn addSubview:mainMomentLabel];
        
        mainMineBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        mainMineBtn.frame=CGRectMake(ScreenW-ScreenW/5, 0, ScreenW/5, TabBarViewHeight);
        [mainMineBtn setImage:[UIImage imageNamed:@"tab_main_mine"] forState:UIControlStateNormal];
        [mainMineBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 16, 0)];
        mainMineBtn.tag=105;
        [mainMineBtn addTarget:self action:@selector(buttonChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mainMineBtn];
        
        mainMineLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, TabBarViewHeight - 21, ScreenW/5, 20)];
        mainMineLabel.text=@"我的";
        mainMineLabel.textAlignment=NSTextAlignmentCenter;
        mainMineLabel.font=[UIFont systemFontOfSize:11];
        [mainMineBtn addSubview:mainMineLabel];

        
    }
    return self;
}

- (void)showChatHint
{
    _redLab.hidden = NO;
}

- (void)hideChatHint
{
    _redLab.hidden = YES;
}

- (void)showDgyChatHint
{
    _dgyRedLab.hidden = NO;
}

- (void)hideDgyChatHint
{
    _dgyRedLab.hidden = YES;
}


- (void)selectButton:(NSInteger)index
{
    UIButton *btn = (UIButton *)[self viewWithTag:100+index];
    [self buttonChange:btn];
}

- (void)buttonChange:(id)sender
{
    NSInteger selectIndex=((UIButton *)sender).tag-100;
    
    if (self.currentIndex==selectIndex) {

        BaseNavigationController *nav = (BaseNavigationController *)kAppDelegate.window.rootViewController;
        if (nav.viewControllers.count>0) {
//            if (![[nav.viewControllers firstObject] isKindOfClass:[LoginViewController class]]) {//非登录界面
//                return;
//            }
        }
    }
 
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(tabBarSelectIndex:indexValue:)]) {
            [self.delegate tabBarSelectIndex:self indexValue:selectIndex];
        }
    }
    
    self.currentIndex = selectIndex;
    
    if (sender==mainHomeBtn) {
        //这里把dgyBtn的图片改成选中的图片
        [mainHomeBtn setImage:[UIImage imageNamed:@"tab_main_home_on"] forState:UIControlStateNormal];
        [mainMallBtn setImage:[UIImage imageNamed:@"tab_main_mall"] forState:UIControlStateNormal];
        [mainGlobalBtn setImage:[UIImage imageNamed:@"tab_main_globalhome"] forState:UIControlStateNormal];
        [mainMomentBtn setImage:[UIImage imageNamed:@"tab_main_moments"] forState:UIControlStateNormal];
        [mainMineBtn setImage:[UIImage imageNamed:@"tab_main_mine"] forState:UIControlStateNormal];
        
        [mainHomeLabel setTextColor:RGBACOLOR(26, 174, 229, 1)];
        [mainMallLabel setTextColor:[UIColor blackColor]];
        [mainGlobalLabel setTextColor:[UIColor blackColor]];
        [mainMomentLabel setTextColor:[UIColor blackColor]];
        [mainMineLabel setTextColor:[UIColor blackColor]];

    }
    if (sender==mainMallBtn) {
        [mainHomeBtn setImage:[UIImage imageNamed:@"tab_main_home"] forState:UIControlStateNormal];
        [mainMallBtn setImage:[UIImage imageNamed:@"tab_main_mall_on"] forState:UIControlStateNormal];
        [mainGlobalBtn setImage:[UIImage imageNamed:@"tab_main_globalhome"] forState:UIControlStateNormal];
        [mainMomentBtn setImage:[UIImage imageNamed:@"tab_main_moments"] forState:UIControlStateNormal];
        [mainMineBtn setImage:[UIImage imageNamed:@"tab_main_mine"] forState:UIControlStateNormal];

        
        [mainHomeLabel setTextColor:[UIColor blackColor]];
        [mainMallLabel setTextColor:RGBACOLOR(26, 174, 229, 1)];
        [mainGlobalLabel setTextColor:[UIColor blackColor]];
        [mainMomentLabel setTextColor:[UIColor blackColor]];
        [mainMineLabel setTextColor:[UIColor blackColor]];

    }
    if (sender==mainGlobalBtn) {
        [mainHomeBtn setImage:[UIImage imageNamed:@"tab_main_home"] forState:UIControlStateNormal];
        [mainMallBtn setImage:[UIImage imageNamed:@"tab_main_mall"] forState:UIControlStateNormal];
        [mainGlobalBtn setImage:[UIImage imageNamed:@"tab_main_globalhome_on"] forState:UIControlStateNormal];
        [mainMomentBtn setImage:[UIImage imageNamed:@"tab_main_moments"] forState:UIControlStateNormal];
        [mainMineBtn setImage:[UIImage imageNamed:@"tab_main_mine"] forState:UIControlStateNormal];

        
        [mainHomeLabel setTextColor:[UIColor blackColor]];
        [mainMallLabel setTextColor:[UIColor blackColor]];
        [mainGlobalLabel setTextColor:RGBACOLOR(26, 174, 229, 1)];
        [mainMomentLabel setTextColor:[UIColor blackColor]];
        [mainMineLabel setTextColor:[UIColor blackColor]];

    }
    if (sender==mainMomentBtn) {
        [mainHomeBtn setImage:[UIImage imageNamed:@"tab_main_home"] forState:UIControlStateNormal];
        [mainMallBtn setImage:[UIImage imageNamed:@"tab_main_mall"] forState:UIControlStateNormal];
        [mainGlobalBtn setImage:[UIImage imageNamed:@"tab_main_globalhome"] forState:UIControlStateNormal];
        [mainMomentBtn setImage:[UIImage imageNamed:@"tab_main_moments_on"] forState:UIControlStateNormal];
        [mainMineBtn setImage:[UIImage imageNamed:@"tab_main_mine"] forState:UIControlStateNormal];

        
        [mainHomeLabel setTextColor:[UIColor blackColor]];
        [mainMallLabel setTextColor:[UIColor blackColor]];
        [mainGlobalLabel setTextColor:[UIColor blackColor]];
        [mainMomentLabel setTextColor:RGBACOLOR(26, 174, 229, 1)];
        [mainMineLabel setTextColor:[UIColor blackColor]];

    }
    
    if (sender==mainMineBtn) {
        [mainHomeBtn setImage:[UIImage imageNamed:@"tab_main_home"] forState:UIControlStateNormal];
        [mainMallBtn setImage:[UIImage imageNamed:@"tab_main_mall"] forState:UIControlStateNormal];
        [mainGlobalBtn setImage:[UIImage imageNamed:@"tab_main_globalhome"] forState:UIControlStateNormal];
        [mainMomentBtn setImage:[UIImage imageNamed:@"tab_main_moments"] forState:UIControlStateNormal];
        [mainMineBtn setImage:[UIImage imageNamed:@"tab_main_mine_on"] forState:UIControlStateNormal];
        
        
        [mainHomeLabel setTextColor:[UIColor blackColor]];
        [mainMallLabel setTextColor:[UIColor blackColor]];
        [mainGlobalLabel setTextColor:[UIColor blackColor]];
        [mainMomentLabel setTextColor:[UIColor blackColor]];
        [mainMineLabel setTextColor:RGBACOLOR(26, 174, 229, 1)];
        
    }
}

@end
