//
//  HeaderView.h
//  demo
//
//  Created by 张磊 on 15/11/18.
//  Copyright © 2015年 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HeaderView;


@protocol HearderViewDelegate <NSObject>
- (void)headerView:(HeaderView *)headerView didSelectMenuItemAtIndex:(NSInteger)selectedIndex;

@end
@interface HeaderView : UIView <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,retain) UIButton *backGroundButton;

@property (nonatomic, assign) id <HearderViewDelegate> hearderViewDelegate;
- (instancetype)initWithFrame:(CGRect)frame menuItems:(NSArray *)menuItems view:(UIView *)view;
@property(nonatomic,strong) NSArray *menuItems;
- (void)showInView;
- (void)dismissMenuPopover;
@end
