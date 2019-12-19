//
//  HMHBaseNewViewController.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMHBaseNewViewController : UIViewController

@property (nonatomic,copy)NSString *nvTitle;

@property (nonatomic,strong)UIView *nvView;


/**
 设置子空间
 */
- (void)setSubView;

- (void)initData;

- (void)initNotification;

- (void)removeNotification;

@end

NS_ASSUME_NONNULL_END
