//
//  HFPayMentViewController.h
//  housebank
//
//  Created by usermac on 2018/11/12.
//  Copyright © 2018 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "HFPayMentViewModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef  NS_ENUM(NSInteger,HFPayMentViewControllerEnterType) {
    HFPayMentViewControllerEnterTypeNone = 1,
    HFPayMentViewControllerEnterTypeOther = 2
};
@interface HFPayMentViewController : SpBaseViewController

@property (nonatomic,strong)HFPayMentViewModel *viewModel;
- (instancetype)initWithType:(HFPayMentViewControllerEnterType)contentMode;
- (void)requestPram:(NSArray*)array;
@end

NS_ASSUME_NONNULL_END
