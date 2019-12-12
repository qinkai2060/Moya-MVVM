//
//  WARMomentVoice.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <Foundation/Foundation.h>

@interface WARMomentVoice : NSObject

@property (nonatomic, copy) NSString* duration;
@property (nonatomic, copy) NSString* voiceId;

/** 辅助字段 */
@property (nonatomic, copy) NSString* voiceURLStr;
@property (nonatomic, strong) NSURL* voiceURL;
@property (nonatomic, assign) BOOL isPlaying;

@end
