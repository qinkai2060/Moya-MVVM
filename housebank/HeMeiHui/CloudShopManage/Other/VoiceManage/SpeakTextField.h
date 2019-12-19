//
//  SpeakTextField.h
//  语音搜索
//
//  Created by Tracy on 2019/7/23.
//  Copyright © 2019 liqianhong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeakPopView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpeakTextField : UITextField
@property (nonatomic, strong) SpeakPopView * speakPopView;
- (instancetype)initWithFrame:(CGRect)frame canAddVoice:(BOOL)canAddVoice;
@end

NS_ASSUME_NONNULL_END
