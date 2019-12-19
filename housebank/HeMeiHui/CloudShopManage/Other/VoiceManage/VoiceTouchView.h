//
//  VoiceTouchView.h
//  语音搜索
//
//  Created by Tracy on 2019/7/23.
//  Copyright © 2019 liqianhong. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoiceTouchView : UIView
@property (nonatomic, copy) void (^touchBegan)(void);
@property (nonatomic, copy) void (^upglide)(void);
@property (nonatomic, copy) void (^down)(void);
@property (nonatomic, copy) void (^touchEnd)(void);
@property (nonatomic, strong) UIButton * voiceBtn;
@property (nonatomic) int areaY; // 设置识别高度
@property (nonatomic) int clickTime;// 设置长按时间
@end

NS_ASSUME_NONNULL_END
