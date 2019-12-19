//
//  CutomVipShareView.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/7/23.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^CutomVipShareViewWXBlock)();
typedef void(^CutomVipShareViewPYQBlock)();
typedef void(^CutomVipShareViewCloseBlock)();
@interface CutomVipShareView : UIView
@property (nonatomic, copy) CutomVipShareViewWXBlock wxblock;
@property (nonatomic, copy) CutomVipShareViewPYQBlock pyqblock;
@property (nonatomic, copy) CutomVipShareViewCloseBlock closeblock;
+(instancetype)CutomVipShareViewIn:(UIView *)view addMoney:(float)addMoney goodsDetailModel:(GoodsDetailModel *)goodsDetailModel wxblock:(void(^)())wxblock pyqblock:(void(^)())pyqblock closeblock:(void(^)())closeblock;

@end

NS_ASSUME_NONNULL_END
