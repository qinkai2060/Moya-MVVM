//
//  SpeakPopView.h
//  语音搜索
//
//  Created by Tracy on 2019/7/23.
//  Copyright © 2019 liqianhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceTouchView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^disMissBlock)(void);
typedef void(^callBackBlock)(NSString * string);
typedef void(^touchBegainBlock)(void);
typedef void(^touchEndBlock)(void);
@interface SpeakPopView : UIView
@property (nonatomic, copy)disMissBlock missBlock;
@property (nonatomic, copy)callBackBlock callBackBlock;
@property (nonatomic, copy)touchBegainBlock begainBlock;
@property (nonatomic, copy)touchEndBlock endBlock;
@property (nonatomic, strong) UILabel * topLabel;
@property (nonatomic, strong) VoiceTouchView * voiceView;
- (void)clearPopView;
@end

NS_ASSUME_NONNULL_END
