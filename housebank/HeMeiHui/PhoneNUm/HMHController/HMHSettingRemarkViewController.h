//
//  HMHSettingRemarkViewController.h
//  housebank
//
//  Created by Qianhong Li on 2017/11/3.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHPersonInfoModel.h"
#import "HMHBasePrimaryViewController.h"

typedef void(^remarkCallBack)(NSString *remarkStr);

@interface HMHSettingRemarkViewController : HMHBasePrimaryViewController

@property (nonatomic, strong) NSString *mobilePhone;

@property (nonatomic, strong) NSString *remarkInfo;

@property (nonatomic, copy) remarkCallBack remarkCallBack;

@property (nonatomic, copy) NSString *uid;


@end
