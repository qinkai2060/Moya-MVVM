//
//  ParametersTailesCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/1/17.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParametersTailesCell : UITableViewCell
/* 分类*/
@property (strong , nonatomic)UILabel *titleLab;
/* 内容 */
@property (strong , nonatomic)UILabel *contentLabel;

/* 分割线 */
@property (strong , nonatomic)UILabel *lineLabel;
@end

NS_ASSUME_NONNULL_END
