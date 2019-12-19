//
//  HFYDDetialViewController.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewController.h"
#import "CloudManageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFYDDetialViewController : HFViewController
+(void)showTuiG:(NSString *)shopId vc:(UIViewController*)vc itemModel:(CloudManageItemModel *)itemModel;
+(void)showQRCode:(NSString *)shopId vc:(UIViewController*)vc itemModel:(CloudManageItemModel *)itemModel; // 二维码
@end

NS_ASSUME_NONNULL_END
