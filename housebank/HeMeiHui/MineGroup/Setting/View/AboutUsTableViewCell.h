//
//  AboutUsTableViewCell.h
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AboutUsTableViewCell : UITableViewCell

/**
 标题
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 右箭头
 */
@property (nonatomic, strong) UIImageView *imgNext;

@property (nonatomic, strong) UIView *line;

@end

NS_ASSUME_NONNULL_END
