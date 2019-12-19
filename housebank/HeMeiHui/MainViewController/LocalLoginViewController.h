//
//  LocalLoginViewController.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2017/11/23.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import "HMHViewController.h"
#import "HMHPopAppointViewController.h"
typedef void(^LoginSuccess)();
@interface LocalLoginViewController : HMHViewController

@property (nonatomic, strong) NSString *toUrlStr;

@property (nonatomic, assign) BOOL isFromMine;
@property (nonatomic, copy) LoginSuccess loginSucc;
@property (nonatomic, strong) NSString *mineUrl;

@end
