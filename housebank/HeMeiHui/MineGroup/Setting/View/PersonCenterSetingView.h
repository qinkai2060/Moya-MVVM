//
//  PersonCenterSetingView.h
//  gcd
//
//  Created by 张磊 on 2019/4/24.
//  Copyright © 2019 张磊. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PersonCenterSetingViewClickType) {
    PersonCenterSetingViewClickTypeLoginOut,//退出登录
    PersonCenterSetingViewClickTypeCellClick,//cell点击
};

/**
 回调block

 @param detail 点击反向传值
 @param type 点击类型
 */
typedef void(^PersonCenterSetingViewClickBlock)(NSString *detail,PersonCenterSetingViewClickType type);

@interface PersonCenterSetingView : UIView
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *arrDateSoure;
@property (nonatomic, copy) PersonCenterSetingViewClickBlock setttinBlock;
@end

NS_ASSUME_NONNULL_END
