//
//  CustomHUDView.h
//  VideoDownLoade
//
//  Created by Qianhong Li on 2018/3/1.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^hubBackBtnClick)();

@interface HMHCustomHUDView : UIView

@property (nonatomic, copy) hubBackBtnClick hubBtnClick;

// 返回按钮
@property (nonatomic, strong) UIButton *backBtn;

- (void)showMBProgressHUD;
- (void)hideMBProgressHUD;

@end
