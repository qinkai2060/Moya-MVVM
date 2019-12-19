//
//  HFYDDetialMainView.h
//  HeMeiHui
//
//  Created by usermac on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFView.h"
#import "WRCustomNavigationBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFYDDetialMainView : HFView
@property(nonatomic,assign)BOOL canScroll;
@property(nonatomic,assign)BOOL appcanScroll;
@property(nonatomic,strong)WRCustomNavigationBar *customNavBar;

@end

NS_ASSUME_NONNULL_END
