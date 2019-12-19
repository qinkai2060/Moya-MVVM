//
//  HMHPhoneBookDetailInfoModel.h
//  housebank
//
//  Created by Qianhong Li on 2017/11/29.
//  Copyright © 2017年 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface HMHPhoneBookDetailInfoModel : BaseModel

// 用户id
@property (nonatomic, strong) NSString *uid;
// 用户id
@property (nonatomic, strong) NSString *nickname;
// <头像id，此处是从数据库中返回一部分，需要自己拼接>
@property (nonatomic, strong) NSString *imagePath;
// <是否关注 true已关注，false未关注>
@property (nonatomic, strong) NSString *follow;
// 备注
@property (nonatomic, strong) NSString *contactRemark;
// <是否会员，true是，false否>
@property (nonatomic, strong) NSString *member;
// 最近4个媒体链接
@property (nonatomic, strong) NSString *pubMedia;
// 最近4个媒体链接的类型 1 图片 2 视频
@property (nonatomic, strong) NSString *recentPubType;
// 邀请角色  （1会员 2门店 3 不显示邀请）
@property (nonatomic, strong) NSString *inviteRole;
// 手机号
@property (nonatomic, strong) NSString *mobilePhone;

@property (nonatomic, strong) NSString *cityName;
@property (nonatomic, strong) NSString *regionName;
@property (nonatomic, strong) NSString *blockName;

@end
