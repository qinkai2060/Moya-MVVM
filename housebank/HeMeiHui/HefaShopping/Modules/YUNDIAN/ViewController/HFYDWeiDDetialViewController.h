//
//  HFYDWeiDDetialViewController.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFViewController.h"
#import "CloudManageModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFYDWeiDDetialViewController : HFViewController
+(void)showQRCode:(NSString *)shopId vc:(UIViewController*)vc itemModel:(CloudManageItemModel *)itemModel;
+(void)showTuiG:(NSString *)shopId vc:(UIViewController*)vc itemModel:(CloudManageItemModel *)itemModel;
@end

NS_ASSUME_NONNULL_END
