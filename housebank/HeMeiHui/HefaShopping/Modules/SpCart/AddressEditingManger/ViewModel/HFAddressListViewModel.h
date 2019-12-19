//
//  HFAddressListViewModel.h
//  housebank
//
//  Created by usermac on 2018/11/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFViewModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, HFAddressListViewModelSource) {
    HFAddressListViewModelSourcePay = 0,
    HFAddressListViewModelSourceMine = 1,
};

@interface HFAddressListViewModel : HFViewModel
@property(nonatomic,assign)HFAddressListViewModelSource fromeSource;

@property(nonatomic,strong)HFAddressModel *model;

/**
 区分进入VC类型
 */
@property(nonatomic,assign)NSInteger source;

/**
 编辑和修改地址
 */
@property(nonatomic,copy)NSDictionary *pramsAddorEditAddress;

/**
 数据绑定
 */
@property(nonatomic,strong)RACSignal *validSigal;
/**
 设置默认地址
 */
@property(nonatomic,strong)RACSubject *editingSetSubjc;
/**
 设置默认地址
 */
@property(nonatomic,strong)RACCommand *defualtAddressCommnd;
/**
 设置默认地址
 */
@property(nonatomic,strong)RACSubject *deleteSubjc;
/**
 设置默认地址
 */
@property(nonatomic,strong)RACCommand *deleteAddressCommnd;

/**
 默认地址
 */
@property(nonatomic,strong)RACSubject *resultSubjc;

/**
 参数
 */
@property(nonatomic,copy)NSString *addressid;
/**
 地址列表请求
 */
@property(nonatomic,strong)RACCommand *addressListComand;

/**
 编辑地址网络
 */
@property(nonatomic,strong)RACCommand *addressEditComand;

/**
 保存编辑的地址
 */
@property(nonatomic,strong)RACSubject *addressEditSubjc;

/**
 收货地址列表
 */
@property(nonatomic,strong)RACSubject *addressSubjc;

/**
 选中地址
 */
@property(nonatomic,strong)RACSubject *didSelectSubjc;

/**
 新增新地址
 */
@property(nonatomic,strong)RACSubject *addNewaddressSubjc;

/**
 编辑原有地址
 */
@property(nonatomic,strong)RACSubject *editingOriginSubjc;
/**
 获取地址
 */
@property(nonatomic,strong)RACCommand *regionCommand;
@property(nonatomic,strong)RACSubject *regionsubject;
@property(nonatomic,strong)RACSubject *didSelectregionsubject;
@property(nonatomic,assign) NSInteger regionId;
@property(nonatomic,assign)NSInteger level;
+ (BOOL)isContain:(NSString*)ids;
@end

NS_ASSUME_NONNULL_END
