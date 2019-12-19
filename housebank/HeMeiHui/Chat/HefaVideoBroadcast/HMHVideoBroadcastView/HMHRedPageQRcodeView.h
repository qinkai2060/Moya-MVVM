//
//  HMHRedPageQRcodeView.h
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/5/31.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
// 生成红包二维码 还可下载(保存到相册)
@interface HMHRedPageQRcodeView : UIView

- (instancetype)initWithFrame:(CGRect)frame topName:(NSString *)title QRCodeUrl:(NSString *)codeUrl bottomStr:(NSString *)bottmStr;


- (void)show;
- (void)hide;

@end
