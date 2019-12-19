//
//  CloudManageModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface CloudManageItemModel : NSObject <JXModelProtocol, NSCoding>
@property (nonatomic, copy) NSString * address;
@property (nonatomic, copy) NSString * auditTime;
@property (nonatomic, copy) NSString * cityId;
@property (nonatomic, copy) NSString * createDate;
@property (nonatomic, copy) NSString * logoImg;
@property (nonatomic, copy) NSString * mobile;
@property (nonatomic, copy) NSString * point_lat;
@property (nonatomic, copy) NSString * provinceId;
@property (nonatomic, copy) NSString * regionId;
@property (nonatomic, copy) NSString * shopId;
@property (nonatomic, copy) NSString * shopImg;
@property (nonatomic, copy) NSString * shopName;
@property (nonatomic, copy) NSString * shopType;
@property (nonatomic, copy) NSString * state;
@property (nonatomic ,copy) NSString * townId;
@property (nonatomic, copy) NSString * updateTime;
@property (nonatomic, copy) NSString * auditRemark;
@property (nonatomic, copy) NSString * localAddress;
@property (nonatomic, copy) NSString * fullAddress;
@property (nonatomic, copy) NSString * contact;
@property (nonatomic, copy) NSString * pointLat;
@property (nonatomic, copy) NSString * pointLng;
@property (nonatomic, copy) NSString * shopImgId;
@property (nonatomic, copy) NSString * logoImgId;
@end

@interface CloudManageModel : NSObject <JXModelProtocol, NSCoding>
@property (nonatomic, strong) NSArray <CloudManageItemModel *> * dataSource;
@end
NS_ASSUME_NONNULL_END
