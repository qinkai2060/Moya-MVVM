//
//  MyAcountSecurityCell.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/27.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyAcountSecurityCell : UITableViewCell
/**
 标题
 */
@property (nonatomic, strong) UILabel *titleL;
/**
 右箭头
 */
@property (nonatomic, strong) UIImageView *imgNext;

/**
 右箭头
 */
@property (nonatomic, strong) UIView *cornerView;
@end

NS_ASSUME_NONNULL_END
