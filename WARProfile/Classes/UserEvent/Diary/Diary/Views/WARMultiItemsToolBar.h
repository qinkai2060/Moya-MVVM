//
//  WARMultiItemsToolBar.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/21.
//

#import <UIKit/UIKit.h>

#define MultiItemsToolBarScrollViewHeight 30

@class WARNewUserDiaryMonthModel;

@class WARMultiItemsToolBar;
@protocol WARMultiItemsToolBarDelegate <NSObject>
- (void)toolBar:(WARMultiItemsToolBar *)toolBar didSelectedIndex:(NSUInteger)index;
@end

@interface WARMultiItemsToolBar : UIScrollView

@property (nonatomic, copy)NSArray <WARNewUserDiaryMonthModel *>*tags;
 
@property (nonatomic, weak) UIButton *selectedBtn; 
@property (nonatomic, strong) UIFont *btnTitleFont;//按钮字体大小
@property (nonatomic, strong) UIColor *btnTitleSelectColor;//按钮选中字体颜色

@property (nonatomic, weak) id<WARMultiItemsToolBarDelegate> clickDelegate;

- (void)changeTipPlaceWithSmallIndex:(NSUInteger)smallIndex
                            bigIndex:(NSUInteger)bigIndex
                            progress:(CGFloat)progress
                             animate:(BOOL)animate;
- (void)selectedBtnIndex:(NSUInteger)index
                 animate:(BOOL)animate;
@end
