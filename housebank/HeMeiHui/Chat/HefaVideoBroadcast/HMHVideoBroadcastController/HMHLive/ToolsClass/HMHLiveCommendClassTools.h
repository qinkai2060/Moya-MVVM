//
//  HMHLiveCommendClassTools.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/28.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HMHLiveCommendClassTools : NSObject

@property (nonatomic,weak)UIScrollView *currentScrollView;

@property (nonatomic,weak)UINavigationController *nvController;


/**
 单利

 @return HMHLiveCommendClassTools
 */
+ (instancetype)shareManager;

@end

NS_ASSUME_NONNULL_END
