//
//  UserInformationView.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UserInformationViewlClickType) {
    UserInformationViewlClickTypeHeader, //头像
    UserInformationViewlClickTypeUserName, //用户名
    UserInformationViewlClickTypeStoreVip, //门店会员
    UserInformationViewlClickTypeCompanyVip,//企业会员
    UserInformationViewlClickTypeMessage,//消息按钮
    UserInformationViewlClickTypeSetting,//设置按钮
    UserInformationViewlClickTypeMoney,//我的资产按钮
    UserInformationViewlClickTypePerformance,//我的业绩
    UserInformationViewlClickTypeVipTag,//会员标签
    UserInformationViewlClickTypeVip//vip
};

typedef void(^UserInformationViewlClickBlock)(UserInformationViewlClickType flag);

@interface UserInformationView : UIView
@property(nonatomic,strong)UIButton *iconBtn;//头像
@property(nonatomic,strong)UIButton *nameBtn;//x用户名
@property(nonatomic,strong)UIButton *storeMemberBtn;//门店会员
@property(nonatomic,strong)UIButton *corporateMemberBtn;//企业会员
@property(nonatomic,strong)UIButton *setUpBtn;//s设置按钮
@property(nonatomic,strong)UIButton *newsBtn;//消息按钮
@property(nonatomic,strong)UIButton *myAssetsBtn;//我的资产按钮按钮
@property(nonatomic,strong)UIButton *myPerformance;//我的业绩
@property(nonatomic,strong)UIButton *vipTagBtn;//vip标签
@property(nonatomic,strong)UIButton *vipBtn;//进入vip



@property (nonatomic, copy) UserInformationViewlClickBlock clickBlock;
- (void)refreshHeaderWithModel:(UserInfoModel*)model;
@end

NS_ASSUME_NONNULL_END
