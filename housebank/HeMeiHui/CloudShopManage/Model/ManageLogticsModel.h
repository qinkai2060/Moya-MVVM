//
//  ManageLogticsModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
#import "ManageLogticsListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageLogticsModel : NSObject<JXModelProtocol, NSCoding>
@property (nonatomic, copy) NSString * id;               // 主键
@property (nonatomic, copy) NSString * orderId;          // 订单
@property (nonatomic, assign) NSInteger expressId;        // 快递公司
@property (nonatomic, copy) NSString * expTextName;
@property (nonatomic, copy) NSString * mailNo;
@property (nonatomic, copy) NSString * code;             // 快递公司编号
@property (nonatomic, copy) NSString * expressOrderNo;   // 快递单号
@property (nonatomic, copy) NSString * createDate;       // 创建时间
@property (nonatomic, copy) NSString * createUser;       // 创建人
@property (nonatomic, copy) NSString * updateDate;       // 修改时间
@property (nonatomic, copy) NSString * updateUser;       // 修改人
@property (nonatomic, copy) NSString * logisticsData;    // 物流数据
@property (nonatomic, copy) NSString * lastSearchDate;   // 最后查询时间
@property (nonatomic, copy) NSString * deliverName;      // 发货人
@property (nonatomic, copy) NSString * deliverPhone;     // 发货人手机
@property (nonatomic, copy) NSString * fhName;
@property (nonatomic, copy) NSString * mobilephone;
@property (nonatomic, strong) NSArray <ManageLogticsListModel *> * listArray;
@property (nonatomic, strong) NSArray * productImage;
@end

NS_ASSUME_NONNULL_END
