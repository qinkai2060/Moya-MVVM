//
//  CheckShopsModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/29.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
#import <YYKit/YYKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface TownAgent :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger agentId;
@property (nonatomic , assign) NSInteger chainUid;
@property (nonatomic , assign) NSInteger agentPhone;
@property (nonatomic , assign) NSInteger cityId;
@property (nonatomic , assign) NSInteger regionId;
@property (nonatomic , assign) NSInteger agentType;
@property (nonatomic , copy) NSString * appDate;
@property (nonatomic , copy) NSString * pfDate;
@property (nonatomic , copy) NSString * isuse;
@property (nonatomic , copy) NSString *approvalStatus;
@property (nonatomic , copy) NSString * restMoney;
@property (nonatomic , copy) NSString *firHosueMoney;
@property (nonatomic , copy) NSString * secHosueMoney;
//@property (nonatomic , copy) NSString *newMemberMoney;
@property (nonatomic , copy) NSString *allFamilyMoney;
@property (nonatomic , copy) NSString *withdrawalMoney;
@property (nonatomic , copy) NSString *stopedMoney;
@property (nonatomic , copy) NSString *homeMoney;
@property (nonatomic , copy) NSString *integralAmount;
@property (nonatomic , copy) NSString * forbidDate;
@property (nonatomic , assign)NSInteger townId;
@property (nonatomic , copy) NSString * provinceName;
@property (nonatomic , copy) NSString *cityName;
@property (nonatomic , copy) NSString *regionName;
@property (nonatomic , copy) NSString *approvalReason;
@property (nonatomic , copy) NSString *approvalPerson;
@property (nonatomic , assign)NSInteger refereeId;
@property (nonatomic , copy) NSString *refereePhone;
@property (nonatomic , copy) NSString *initialFee;
@property (nonatomic , copy) NSString * payMoney;
@property (nonatomic , copy) NSString *memberUpMoney;
//@property (nonatomic , copy) NSString *newAgentMoney;
@property (nonatomic , copy) NSString *bizType;
@property (nonatomic , copy) NSString *chainName;
@property (nonatomic , copy) NSString *refereeName;
@property (nonatomic , copy) NSString *signDate;
@property (nonatomic , copy) NSString *payDate;
@property (nonatomic , copy) NSString *refereeFeeFlag;
@property (nonatomic , copy) NSString *cityFeeFlag;
@property (nonatomic , copy) NSString *bizFeeFlag;
@property (nonatomic , copy) NSString *countMonth;
@property (nonatomic , copy) NSString *confirm;
@property (nonatomic , copy) NSString *payId;
@property (nonatomic , copy) NSString *certificate;
@property (nonatomic , copy) NSString *refundFlag;
@property (nonatomic , copy) NSString *orderSubId;
@property (nonatomic , copy) NSString *payType;
@property (nonatomic , copy) NSString *paidTransfer;
@property (nonatomic , copy) NSString *virtualFlag;
@property (nonatomic , copy) NSString *ext5;
@property (nonatomic , copy) NSString *townName;
@property (nonatomic , copy) NSString *ext4;
@property (nonatomic , copy) NSString *orderNo;
@property (nonatomic , copy) NSString *ext2;

@end
@interface RegionAgent :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger agentId;
@property (nonatomic , assign) NSInteger              chainUid;
@property (nonatomic , copy) NSString              * agentPhone;
@property (nonatomic , assign) NSInteger              cityId;
@property (nonatomic , assign) NSInteger              regionId;
@property (nonatomic , assign) NSInteger              agentType;
@property (nonatomic , copy) NSString * appDate;
@property (nonatomic , copy) NSString * pfDate;
@property (nonatomic , copy) NSString * isuse;
@property (nonatomic , copy) NSString *approvalStatus;
@property (nonatomic , copy) NSString * restMoney;
@property (nonatomic , copy) NSString *firHosueMoney;
@property (nonatomic , copy) NSString * secHosueMoney;
//@property (nonatomic , copy) NSString *newMemberMoney;
@property (nonatomic , copy) NSString *allFamilyMoney;
@property (nonatomic , copy) NSString *withdrawalMoney;
@property (nonatomic , copy) NSString *stopedMoney;
@property (nonatomic , copy) NSString *homeMoney;
@property (nonatomic , copy) NSString *integralAmount;
@property (nonatomic , copy) NSString * forbidDate;
@property (nonatomic , assign)NSInteger townId;
@property (nonatomic , copy) NSString * provinceName;
@property (nonatomic , copy) NSString              * cityName;
@property (nonatomic , copy) NSString              * regionName;
@property (nonatomic , copy) NSString *approvalReason;
@property (nonatomic , copy) NSString *approvalPerson;
@property (nonatomic , assign)NSInteger refereeId;
@property (nonatomic , copy) NSString *refereePhone;
@property (nonatomic , copy) NSString *initialFee;
@property (nonatomic , copy) NSString * payMoney;
@property (nonatomic , copy) NSString *memberUpMoney;
//@property (nonatomic , copy) NSString *newAgentMoney;
@property (nonatomic , copy) NSString *bizType;
@property (nonatomic , copy) NSString *chainName;
@property (nonatomic , copy) NSString *refereeName;
@property (nonatomic , copy) NSString *signDate;
@property (nonatomic , copy) NSString *payDate;
@property (nonatomic , copy) NSString *refereeFeeFlag;
@property (nonatomic , copy) NSString *cityFeeFlag;
@property (nonatomic , copy) NSString *bizFeeFlag;
@property (nonatomic , copy) NSString *countMonth;
@property (nonatomic , copy) NSString *confirm;
@property (nonatomic , copy) NSString *payId;
@property (nonatomic , copy) NSString *certificate;
@property (nonatomic , copy) NSString *refundFlag;
@property (nonatomic , copy) NSString *orderSubId;
@property (nonatomic , copy) NSString *payType;
@property (nonatomic , copy) NSString *paidTransfer;
@property (nonatomic , copy) NSString *virtualFlag;
@property (nonatomic , copy) NSString *ext5;
@property (nonatomic , copy) NSString              * townName;
@property (nonatomic , copy) NSString *ext4;
@property (nonatomic , copy) NSString *orderNo;
@property (nonatomic , copy) NSString *ext2;

@end
@interface CityAgent :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger agentId;
@property (nonatomic , assign) NSInteger              chainUid;
@property (nonatomic , copy) NSString              * agentPhone;
@property (nonatomic , assign) NSInteger              cityId;
@property (nonatomic , assign) NSInteger regionId;
@property (nonatomic , assign) NSInteger              agentType;
@property (nonatomic , copy) NSString * appDate;
@property (nonatomic , copy) NSString * pfDate;
@property (nonatomic , copy) NSString * isuse;
@property (nonatomic , copy) NSString *approvalStatus;
@property (nonatomic , copy) NSString * restMoney;
@property (nonatomic , copy) NSString *firHosueMoney;
@property (nonatomic , copy) NSString * secHosueMoney;
//@property (nonatomic , copy) NSString *newMemberMoney;
@property (nonatomic , copy) NSString *allFamilyMoney;
@property (nonatomic , copy) NSString *withdrawalMoney;
@property (nonatomic , copy) NSString *stopedMoney;
@property (nonatomic , copy) NSString *homeMoney;
@property (nonatomic , copy) NSString *integralAmount;
@property (nonatomic , copy) NSString * forbidDate;
@property (nonatomic , assign) NSInteger              townId;
@property (nonatomic , copy) NSString * provinceName;
@property (nonatomic , copy) NSString              * cityName;
@property (nonatomic , copy) NSString *regionName;
@property (nonatomic , copy) NSString *approvalReason;
@property (nonatomic , copy) NSString *approvalPerson;
@property (nonatomic , assign)NSInteger refereeId;
@property (nonatomic , copy) NSString *refereePhone;
@property (nonatomic , copy) NSString *initialFee;
@property (nonatomic , copy) NSString * payMoney;
@property (nonatomic , copy) NSString *memberUpMoney;
//@property (nonatomic , copy) NSString *newAgentMoney;
@property (nonatomic , copy) NSString *bizType;
@property (nonatomic , copy) NSString *chainName;
@property (nonatomic , copy) NSString *refereeName;
@property (nonatomic , copy) NSString *signDate;
@property (nonatomic , copy) NSString *payDate;
@property (nonatomic , copy) NSString *refereeFeeFlag;
@property (nonatomic , copy) NSString *cityFeeFlag;
@property (nonatomic , copy) NSString *bizFeeFlag;
@property (nonatomic , copy) NSString *countMonth;
@property (nonatomic , copy) NSString *confirm;
@property (nonatomic , copy) NSString *payId;
@property (nonatomic , copy) NSString *certificate;
@property (nonatomic , copy) NSString *refundFlag;
@property (nonatomic , copy) NSString *orderSubId;
@property (nonatomic , copy) NSString *payType;
@property (nonatomic , copy) NSString *paidTransfer;
@property (nonatomic , copy) NSString *virtualFlag;
@property (nonatomic , copy) NSString *ext5;
@property (nonatomic , copy) NSString              * townName;
@property (nonatomic , copy) NSString *ext4;
@property (nonatomic , copy) NSString *orderNo;
@property (nonatomic , copy) NSString *ext2;

@end
@interface CheckData :NSObject<NSCoding>
@property (nonatomic , assign) NSInteger regOrder;//待支付的rm注册订单id，0代表没有

@property (nonatomic , assign) NSInteger              RMAgent;//镇代审核状态，0未审核，1复核通过，2复核未通过，3、审核通过，4、审核失败 5、申请中（APP） 6、待支付（APP） 7、取消 8、不是镇代

//agentWhite：1：空投街镇代会员，进入用户首页跳转到空投注册页面；0不是空投；
@property (nonatomic , assign) NSInteger              agentWhite;//是否赠送镇代资格，0：不是，1：空点(赠送) 2：百万俱乐部

@property (nonatomic , assign) NSInteger              RMGrade;//会员等级，1：免费会员，2：初级门店，3：中级门店，4：高级门店
@property (nonatomic , assign) NSInteger proxyRegOrder;//待支付的rm代注册订单id，0代表没有
@property (nonatomic , assign) NSInteger upgradeOrder;//待支付的rm升级订单id，0代表没有
//0:未提交，1:待审核，2:审核未通过，3:审核通过，4:已下线(删除），5:审核通过（已缴费，针对盗龄店铺），6:已下架
//状态不同跳转的页面不一样；显示的内容也不一样；
//1，2，3和6：显示商城店铺管理；0，4显示入驻；
@property (nonatomic , assign) NSInteger              hfShopsState;//合发购店铺状态
@property (nonatomic , assign) BOOL                   isOtoShops;//是否有OTO店铺
@property (nonatomic , assign) BOOL                   isHfShops;//是否有合发购店铺
@property (nonatomic , strong) TownAgent              * townAgent;
@property (nonatomic , strong) CityAgent                *cityAgent;
@property (nonatomic , strong) RegionAgent                *regionAgent;
@property (nonatomic , assign) BOOL       canBuyAgtProduct;//true-可以购买，false-不可以购买(代理商品)。且CityAgent也可以购买

@property (nonatomic , strong) NSNumber                *hasCloudShops;//微店和OTO店铺总数)大于0 表示you云店
@property (nonatomic , assign) BOOL                    isSalesOrder;//是否有销售订单

@end



@interface CheckShopsModel : SetBaseModel
@property (nonatomic , strong) CheckData              * data;
@end

NS_ASSUME_NONNULL_END
