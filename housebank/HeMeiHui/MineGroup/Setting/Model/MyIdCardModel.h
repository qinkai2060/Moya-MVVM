//
//  MyIdCardModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/9/26.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyIdCardModel : NSObject

@property (nonatomic, strong) NSString *name;//姓名
@property (nonatomic, strong) NSString *mobilephone;//手机号
@property (nonatomic, strong) NSString *phone;//常用人电话
@property (nonatomic, strong) NSString *email;//邮箱
@property (nonatomic, strong) NSString *selfAdress;//地址
@property (nonatomic, strong) NSString *agentType;//代理类型，1-城代，2、3、4-片代，5-镇代
@property (nonatomic, strong) NSString *chainRole;//门店角色，1-免费会员，2-初级门店，3-中级门店，4-高级门店
@property (nonatomic, strong) NSString *credentialsNumber;//证件号
@property (nonatomic, strong) NSString *createDate ;//创建时间
@property (nonatomic, strong) NSString *updateDate;//更新时间
@property (nonatomic, strong) NSString *isAgent ;//是否代理
@property (nonatomic, strong) NSString *cityName;//城市名称
@property (nonatomic, strong) NSString *regionName;//区名称
@property (nonatomic, strong) NSString *cardPositivePath;//名片正面图片路径
@property (nonatomic, strong) NSString *cardOtherPath;//名片反面图片路径
@property (nonatomic, strong) NSString *cardPositiveId;//名片正面图片id
@property (nonatomic, strong) NSString *cardOtherId;//名片反面图片id
@property (nonatomic, strong) NSString *title;//职称
@property (nonatomic, strong) NSString * position;//职位
@end

NS_ASSUME_NONNULL_END
