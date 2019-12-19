//
//  UserOrderCell.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/26.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, UserOrderCellClickType) {
    UserOrderCellClickTypeAll, //全部
    UserOrderCellClickTypePendingPayment, //代付款
    UserOrderCellClickTypeToBeShipped, //待发货
    UserOrderCellClickTypeGoodsReceived, //待收货
    UserOrderCellClickTypeGrade,//评价
    UserOrderCellClickTypeRefund//退款
};

typedef void(^UserOrderCellClickBlock)(UserOrderCellClickType type);

@interface UserOrderCell : UITableViewCell
@property (nonatomic, copy) UserOrderCellClickBlock clikBlock; 
@end

NS_ASSUME_NONNULL_END
