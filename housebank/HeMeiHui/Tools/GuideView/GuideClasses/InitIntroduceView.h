//
//  InitIntroduceView.h
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
// 引导页
@protocol SpInitIntroduceViewDelegate <NSObject>
-(void)reSetTabBarHidden;
@end

@interface InitIntroduceView : UIView
@property(nonatomic,weak)id<SpInitIntroduceViewDelegate> Delegate;

@end

NS_ASSUME_NONNULL_END
