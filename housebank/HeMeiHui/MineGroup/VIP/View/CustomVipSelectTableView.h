//
//  CustomVipSelectTableView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CustomVipSelectTableViewType) {
    CustomVipSelectTableViewTypeTreturnoOnProfit, //返利
    CustomVipSelectTableViewTypeBuyWholesale //批发
};

typedef void(^CustomVipSelectTableViewClickSureBlock)();
typedef void(^CustomVipSelectTableViewClickCloseBlock)();
@interface CustomVipSelectTableView : UIView
@property (nonatomic, copy) CustomVipSelectTableViewClickSureBlock sureblock;
@property (nonatomic, copy) CustomVipSelectTableViewClickCloseBlock closeblock;
+(instancetype)CustomVipSelectTableViewIn:(UIView *)view arrDate:(NSArray *)arrDate viewType:(CustomVipSelectTableViewType)viewType sureblock:(void(^)())sureblock closeblock:(void(^)())closeblock;
@end

NS_ASSUME_NONNULL_END
