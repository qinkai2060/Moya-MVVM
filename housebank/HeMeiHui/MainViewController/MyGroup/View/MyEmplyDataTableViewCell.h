//
//  MyEmplyDataTableViewCell.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/24.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyEmplyDataTableViewCell : UITableViewCell
@property (nonatomic, copy) NSString * emptyString;
@property (nonatomic, strong) UILabel * alertLabel;
@property (nonatomic, copy) NSString * imageString;
- (void)reloadString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
