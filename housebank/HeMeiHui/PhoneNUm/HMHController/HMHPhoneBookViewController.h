//
//  HMHPhoneBookViewController.h
//  PhoneNumDemo
//
//  Created by Qianhong Li on 2017/8/31.
//  Copyright © 2017年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HMHPhoneBookViewController : UIViewController
typedef void(^PhoneBookInviteClick)(NSString * phoneNum);

@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, copy) NSString *color;
@property (nonatomic, assign) BOOL isShowNavi;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *mobilePhone;
@property (nonatomic, copy)PhoneBookInviteClick InviteClick;

@end
