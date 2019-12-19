//
//  HFVIPMainView.h
//  HeMeiHui
//
//  Created by usermac on 2019/7/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFVIPMainView : HFView
@property(nonatomic,assign)BOOL canScroll;
@property(nonatomic,assign)BOOL bottomEnabled;
- (void)Behavior;
@end

NS_ASSUME_NONNULL_END
