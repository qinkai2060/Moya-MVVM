//
//  HMHGoodsPushAlertView.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/4.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^goodsInfoClickBlock)();

// xx购买了该商品
@interface HMHGoodsPushAlertView : UIView

@property (nonatomic, strong) goodsInfoClickBlock goodsClickBlock;

// 用户头像url  显示内容
- (instancetype)initWithFrame:(CGRect)frame userIconUrl:(NSString *)iconUrl  contentStr:(NSString *)contentStr isShowTime:(NSInteger)showTime;

- (void)show;
- (void)hide;

@end
