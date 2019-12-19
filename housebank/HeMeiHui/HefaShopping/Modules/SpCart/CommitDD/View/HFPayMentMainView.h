//
//  HFPayMentMainView.h
//  housebank
//
//  Created by usermac on 2018/11/12.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "HFView.h"
#import "HFPayMentViewController.h"
@class HFAddressModel;
NS_ASSUME_NONNULL_BEGIN

@interface HFPayMentMainView : HFView
//@property (nonatomic,assign) HFPayMentViewControllerEnterType contentMode;
- (void)requstData:(HFAddressModel*)modeldata;
@end

NS_ASSUME_NONNULL_END
