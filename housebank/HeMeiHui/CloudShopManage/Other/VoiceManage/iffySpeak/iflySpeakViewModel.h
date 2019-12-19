//
//  iflySpeakViewModel.h
//  语音搜索
//
//  Created by Tracy on 2019/7/23.
//  Copyright © 2019 liqianhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFlyMSC/IFlyMSC.h"

@class IFlySpeechRecognizer;
NS_ASSUME_NONNULL_BEGIN

@interface iflySpeakViewModel : NSObject
@property (nonatomic, strong) IFlySpeechRecognizer * speakRecongizer;
@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;

/**
 parse JSON data
 **/
- (NSString *)stringFromJson:(NSString*)params;//


/**
 parse JSON data for cloud grammar recognition
 **/
- (NSString *)stringFromABNFJson:(NSString*)params;

- (void)initRecognizer;
- (void)initWtihPcmRecorder;
@end

NS_ASSUME_NONNULL_END
