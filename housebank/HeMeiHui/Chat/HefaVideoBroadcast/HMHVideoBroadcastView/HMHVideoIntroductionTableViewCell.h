//
//  HMHVideoIntroductionTableViewCell.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/24.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
// 简介 -- cell
@interface HMHVideoIntroductionTableViewCell : UITableViewCell

- (void)refreshWithText:(NSString *)text;

+(CGFloat)cellHeightWithText:(NSString *)text;


@end
