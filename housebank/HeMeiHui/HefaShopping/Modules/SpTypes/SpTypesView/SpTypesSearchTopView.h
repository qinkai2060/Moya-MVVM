//
//  SpTypesSearchTopView.h
//  housebank
//
//  Created by liqianhong on 2018/10/26.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol searchTopViewDelegate <NSObject>

/**
    四个按钮的点击事件 btnTag为当前所选中的按钮的tag
    numState 为销量的状态值 当tag为销量时 此值有效
    priceState 为价格的状态值 当tag为价格时 此值有效
 */
- (void)topBtnClickWithTag:(NSInteger)btnTag numState:(BOOL)numState priceState:(BOOL)priceState;

@end

@interface SpTypesSearchTopView : UIView

@property (nonatomic, weak) id<searchTopViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
