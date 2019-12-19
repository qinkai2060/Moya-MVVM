//
//  NavigationBarTitleView.h
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^NavigationBarTitleViewClickBlock)(BOOL isOpen);

@interface NavigationBarTitleView : UIView
@property(nonatomic, strong) UIButton *btnmMyOrder;
@property(nonatomic, assign) CGSize intrinsicContentSize;

/**
 点击回调
 */
@property (nonatomic, copy) NavigationBarTitleViewClickBlock clickBlock;

/**
 改变navigation Title

 @param title Title
 */
- (void)changeBtnTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
