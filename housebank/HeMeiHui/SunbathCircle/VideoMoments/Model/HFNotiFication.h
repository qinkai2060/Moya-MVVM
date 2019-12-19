//
//  HFNotiFication.h
//  HeMeiHui
//
//  Created by usermac on 2019/12/18.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, HFNotiFicationState) {
    HFNotiFicationStateForeground,  // Enter the foreground from the background.
    HFNotiFicationStateBackground,  // From the foreground to the background.
};

NS_ASSUME_NONNULL_BEGIN

@interface HFNotiFication : NSObject
@property (nonatomic, readonly) HFNotiFicationState backgroundState;

@property (nonatomic, copy, nullable) void(^willResignActive)(HFNotiFication *registrar);

@property (nonatomic, copy, nullable) void(^didBecomeActive)(HFNotiFication *registrar);

@property (nonatomic, copy, nullable) void(^newDeviceAvailable)(HFNotiFication *registrar);

@property (nonatomic, copy, nullable) void(^oldDeviceUnavailable)(HFNotiFication *registrar);

@property (nonatomic, copy, nullable) void(^categoryChange)(HFNotiFication *registrar);

@property (nonatomic, copy, nullable) void(^volumeChanged)(float volume);

@property (nonatomic, copy, nullable) void(^audioInterruptionCallback)(AVAudioSessionInterruptionType interruptionType);

- (void)addNotification;

- (void)removeNotification;

@end

NS_ASSUME_NONNULL_END
