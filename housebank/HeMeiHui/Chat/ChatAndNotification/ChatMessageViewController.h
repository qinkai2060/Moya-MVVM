//
//  ChatMessageViewController.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2017/11/6.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESSessionListViewController.h"

typedef void(^contacTableViewCallBack)(NSString * phoneNum,NSString *uid);

@interface ChatMessageViewController : NTESSessionListViewController

@property (nonatomic, copy) contacTableViewCallBack acontactCallBack;

@property (nonatomic,copy)NSString *urlStr;
@property (nonatomic,copy)NSString *naTitle;
@property (nonatomic,assign) BOOL isShowNaBar ;
@property (nonatomic, assign) NSInteger StateValue;
@property (nonatomic, copy) NSString *BgColor;

@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *mobilephone;
@property (nonatomic, strong) NSString *appMsgUrl;
@property (nonatomic, strong) NSString *expressRouterMsgUrl;
@property (nonatomic, strong) NSString *loginUrl;
@property (nonatomic, assign) NSInteger systemMsgCount;
@property (nonatomic, assign) NSInteger expRouterMsgCount;






@end
