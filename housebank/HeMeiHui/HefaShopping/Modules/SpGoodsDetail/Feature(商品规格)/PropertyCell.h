//
//  PropertyCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/21.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PropertyCell : UICollectionViewCell
@property (strong , nonatomic) UILabel *propertyL;

- (void)setTintStyleColor:(UIColor *)color type:(NSString *)type;
- (void)reset:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
