//
//  RememberVC.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/16.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RememberVCInstance : NSObject
@property(nonatomic,strong)UIViewController *goOutVC;
@property(nonatomic,assign)NSUInteger count;
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
