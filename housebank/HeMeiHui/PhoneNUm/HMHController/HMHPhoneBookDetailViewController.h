//
//  HMHPhoneBookDetailViewController.h
//  housebank
//
//  Created by Qianhong Li on 2017/11/2.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHPersonInfoModel.h"
#import "HMHBasePrimaryViewController.h"

typedef void(^upatePersonModel)(HMHPersonInfoModel *personInfoModel);

@interface HMHPhoneBookDetailViewController : HMHBasePrimaryViewController

@property (nonatomic, strong) HMHPersonInfoModel *personInfoModel;

@property (nonatomic, copy) NSString *uid; // 当前登录用户的id

@property (nonatomic, strong) NSString *contactId; // 当前用户的id

@property (nonatomic, copy) upatePersonModel updatePersonModel;

@end
