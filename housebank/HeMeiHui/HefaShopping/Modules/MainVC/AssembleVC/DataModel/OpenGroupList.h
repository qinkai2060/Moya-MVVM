//
//  OpenGroupList.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/3.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
#import <YYKit/YYKit.h>
@protocol OpenGroupListItem//不带*号

@end
NS_ASSUME_NONNULL_BEGIN
@interface OpenGroupListItem :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger              ID;//开团ID
@property (nonatomic , assign) NSInteger              userId;//用户id
@property (nonatomic , assign) NSInteger              parentId;//为0则这条记录为团主否则为团员
@property (nonatomic , assign) NSInteger              productActiveId;//活动id
@property (nonatomic , copy) NSString              * orderNo;//订单号
@property (nonatomic , assign) NSInteger              createDate;//创建日期
@property (nonatomic , assign) NSInteger              newUser;//'0非新人1新人'
@property (nonatomic , assign) NSInteger              payState;//0未支付 1已支付
@property (nonatomic , assign) NSInteger              groupNum;//本团参团人数
@property (nonatomic , assign) NSInteger              activeNum;//团活动人数
@property (nonatomic , copy) NSString              * nickname;//用户昵称
@property (nonatomic , copy) NSString              * name;//用户名称
@property (nonatomic , copy) NSString              * imagePath;
@property (nonatomic , assign) NSInteger              initialNumber;
@property (nonatomic , assign) NSInteger              activeType;

@end


@interface OpenGroup :NSObject<NSCoding>
@property (nonatomic , strong) NSArray <OpenGroupListItem >              * openGroupList;
@property (nonatomic , assign) NSInteger              manageCount;//开团人数
@property (nonatomic , assign) NSInteger              memberCount;//成功人数
@property (nonatomic , assign) NSInteger              isNewUser ;//0：非新人，1：新人，2：未登录

@end


@interface OpenGroupList :SetBaseModel

@property (nonatomic , strong) OpenGroup              * data;

@end



NS_ASSUME_NONNULL_END
