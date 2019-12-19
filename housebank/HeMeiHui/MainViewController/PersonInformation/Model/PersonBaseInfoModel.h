//
//  PersonBaseInfoModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface PersonBaseInfoModel : NSObject<NSCoding>
@property (nonatomic, copy) NSString * userId;     // 用户id
@property (nonatomic, copy) NSString * name;       // 姓名
@property (nonatomic, copy) NSString * loginName;  // 登陆名
@property (nonatomic, copy) NSString * head_url;   // 头像
@property (nonatomic, copy) NSString * nickname;   // 昵称
@property (nonatomic, assign) NSInteger  authStatus; // 认证状态
@property (nonatomic, copy) NSString * companyId;  // 所属公司id
@property (nonatomic, copy) NSString * companyName;// 所属公司名称
@property (nonatomic, copy) NSString * storeId;    // 所属门店id
@property (nonatomic, copy) NSString * storeName;  // 所属门店名称
@property (nonatomic, copy) NSString * mobilephone; // 联系手机
@property (nonatomic, copy) NSString * telphone;    // 备用电话
@property (nonatomic, copy) NSString * email ;      // 邮箱
@property (nonatomic, copy) NSString * selfAdress;  // 个人地址
@property (nonatomic, copy) NSString * identity;     // 身份证
@property (nonatomic, copy) NSString * identityType; // 证件号类型
@property (nonatomic, copy) NSString * identity_url; // 身份证地址
@property (nonatomic, copy) NSString * cardName;     // 银行户名
@property (nonatomic, copy) NSString * cardNo;       // 银行卡号
@property (nonatomic, copy) NSString * recommender;  // 邀请人
@property (nonatomic, copy) NSString * recommenderPhone; // 邀请人手机号
@property (nonatomic, copy) NSString * recommendCode;  // 推广码
@property (nonatomic, copy) NSString * recommendType;  // 推荐类型
@property (nonatomic, strong) NSNumber *  gender;         // 性别(0：男 1:男 2:女)
@property (nonatomic, copy) NSString * identityFrontUrl;   // 身份证正面照
@property (nonatomic, copy) NSString * identityBackUrl;    // 身份证背面照
@property (nonatomic, copy) NSString * landlordNickname;   // 房东昵称
@property (nonatomic, copy) NSString * homePersonName;     // 家园邀请人姓名
@property (nonatomic, copy) NSString * homePersonPhone;    // 家园邀请人电话

@end

NS_ASSUME_NONNULL_END
