//
//  MyTabBarView.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2017/11/17.
//  Copyright © 2017年 hefa. All rights reserved.//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@protocol MyTabBarViewDelegate;
@interface MyTabBarView : UIView
{
    id<MyTabBarViewDelegate>_delegate;
    
    UIButton *mainHomeBtn;
    UIButton *mainMallBtn;
    UIButton *mainGlobalBtn;
    UIButton *mainMomentBtn;
    UIButton *mainMineBtn;
    
    UILabel *mainHomeLabel;
    UILabel *mainMallLabel;
    UILabel *mainGlobalLabel;
    UILabel *mainMomentLabel;
    UILabel *mainMineLabel;
    
}

@property (nonatomic,strong) id<MyTabBarViewDelegate> delegate;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic,strong) UILabel *redLab;

@property (nonatomic,strong) UILabel *dgyRedLab;//导购园小红点

- (void)selectButton:(NSInteger)index;

//- (void)showChatHint;
//- (void)hideChatHint;
//- (void)showDgyChatHint;
//- (void)hideDgyChatHint;

@end


@protocol MyTabBarViewDelegate <NSObject>

/*按钮切换
 *@param   tabBar
 *@param   index   按钮索引
 *
 */
- (void)tabBarSelectIndex:(MyTabBarView *)tabBar indexValue:(NSInteger)index;

@end
