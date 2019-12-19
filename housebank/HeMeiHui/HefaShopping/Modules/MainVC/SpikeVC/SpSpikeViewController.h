//
//  SpSpikeViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/15.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "SpikeTimeListModel.h"
#import "ShareTools.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpSpikeViewController : SpBaseViewController
@property (nonatomic, strong)UIView * menuVC;
@property (nonatomic, strong) UIScrollView *scrollView;
/** Menu的 纵坐标，不设置默认按照紧贴屏幕上方，如果有导航栏且未隐藏就为64 */
@property (nonatomic, assign) CGFloat gf_menuY;
/** MenuItem 的宽度 */
@property (nonatomic, assign) CGFloat gf_itemWidth;
/** Menu 的高度 */
@property (nonatomic, assign) CGFloat gf_menuHeight;
/** 控制器数组 */
@property (nonatomic, strong) NSArray<UIViewController *> *gf_controllers;
/** 标题数组 */
@property (nonatomic, strong)NSMutableArray *gf_titles;
/** 副标题数组 */
@property (nonatomic, strong)NSMutableArray *gf_subTitles;
/** 设置选中的下标 */
@property (nonatomic, assign) NSInteger gf_selectIndex;
/** 设置选中的下标 */
@property (nonatomic, assign) NSInteger resetselectIndex;
/**
 滚动结束后返回当前下标
 */
@property (nonatomic, copy) void(^gf_curPageIndexBlock)(int curPageIndex);
@property (nonatomic, strong)SpikeTimeListModel *spikeTimeListModel;

@end

NS_ASSUME_NONNULL_END
