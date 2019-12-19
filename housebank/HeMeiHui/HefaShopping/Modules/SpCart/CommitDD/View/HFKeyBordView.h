//
//  HFKeyBordView.h
//  housebank
//
//  Created by usermac on 2018/12/17.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^sureBlock)();
typedef void(^cancelBlock)();
@interface HFKeyBordView : HFView
@property(nonatomic,copy)sureBlock sBlock;
@property(nonatomic,copy)cancelBlock cBlock;
@property(nonatomic,strong)UIView *bottomView;
+ (void)show:(NSNotification*)noti ;
@end

NS_ASSUME_NONNULL_END
