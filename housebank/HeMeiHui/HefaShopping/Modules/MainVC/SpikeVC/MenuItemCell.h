//
//  MenuItemCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/18.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MenuItemCell : UICollectionViewCell
/** 标题内容 */
@property (nonatomic, copy) NSString  *titleText;
/** 标题文字颜色 */
@property (strong, nonatomic) UIColor *titleColor;
/** 标题文字字体 */
@property (strong, nonatomic) UIFont  *titleTextFont;
/** 标题label的高度 */
@property (assign, nonatomic) CGFloat titleLabelHeight;

/** 副标题内容 */
@property (nonatomic, copy) NSString  *subTitleText;
/** 副标题文字颜色 */
@property (strong, nonatomic) UIColor *subTitleColor;
/** 副标题文字字体 */
@property (strong, nonatomic) UIFont  *subTitleTextFont;
/** 副标题label的高度 */
@property (assign, nonatomic) CGFloat subTitleLabelHeight;

@end

NS_ASSUME_NONNULL_END
