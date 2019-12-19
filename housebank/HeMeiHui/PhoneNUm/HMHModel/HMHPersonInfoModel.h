//
//  HMHPersonInfoModel.h
//  PhoneNumDemo
//
//  Created by Qianhong Li on 2017/8/31.
//  Copyright © 2017年 Qianhong Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"


@interface HMHPersonInfoModel : BaseModel

@property (nonatomic, strong) NSString *contactName;

@property (nonatomic, strong) NSString *mobilePhone;

@property (nonatomic, strong)  NSString *contactRole; //（1非会员、2会员、3门店）

@property (nonatomic, strong)  NSString *synchStatus; // (1 新增、2 删除、3 修改)

@property (nonatomic, strong) NSString *inviteRole; // 邀请角色  （1会员 2门店 3 不显示邀请）

@property (nonatomic, strong) NSString *contactPic;

@property (nonatomic, assign) NSInteger mobileID;

@property (nonatomic, copy) NSString *UID;

@property (nonatomic, copy) NSString *contactUserId;   // contactUserId

@property (nonatomic, strong) NSString *contactRemark;
@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSString *blockName;

@end
RLM_ARRAY_TYPE(HMHPersonInfoModel)
