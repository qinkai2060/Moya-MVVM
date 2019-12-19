//
//  PayPopWindowViewController.h
//  HeMeiHui
//
//  Created by 任为 on 2017/8/9.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHBaseViewController.h"
typedef void (^passValue)(NSInteger);

@interface HMHPayPopWindowViewController :HMHBaseViewController
@property (nonatomic,copy)NSString *naTitle;
@property (nonatomic,assign) BOOL isShowNaBar ;
@property (nonatomic, assign) NSInteger StateValue;
@property (nonatomic, copy) passValue pass;
@property (nonatomic, copy) NSString *BgColor;

@end
