//
//  YunDianOrderDetailHeaderView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YunDianOrderListDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol YunDianOrderDetailHeaderViewClickDelegate <NSObject>

- (void)yunDianOrderDetailHeaderViewClickDelegateViewLogistics;//查看物流

@end

@interface YunDianOrderDetailHeaderView : UIView
@property (nonatomic, strong) NSNumber*commented;//评价
@property (nonatomic, strong) YunDianOrderListDetailModel *detailHeaderModel;
@property (nonatomic, strong) NSDictionary *dic_wl;//物流
@property (nonatomic, weak) id <YunDianOrderDetailHeaderViewClickDelegate>delegate;

/**
 状态图片
 */
@property (nonatomic, strong) UIImageView *imgState;

/**
 物流试图
 */
@property (nonatomic, strong) UIView *logisticsView;

/**
 物流状态
 */
@property (nonatomic, strong) UILabel *logisticsStateLabel;

/**
 最新的物流时间
 */
@property (nonatomic, strong) UILabel *latestTimeLabel;
/**
 收件人信息试图
 */
@property (nonatomic, strong) UIView *addresseeView;

/**
 姓名
 */
@property (nonatomic, strong) UILabel *nameLabel;

/**
 收件电话
 */
@property (nonatomic, strong) UILabel *phoneLable;
/**
 收件地址
 */
@property (nonatomic, strong) UILabel *addressLabel;

/**
 复制按钮
 */
@property (nonatomic, strong) UILabel *copyLabel;

@end

NS_ASSUME_NONNULL_END
