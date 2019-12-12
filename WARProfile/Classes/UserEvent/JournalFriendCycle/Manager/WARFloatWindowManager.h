//
//  WARFloatWindowManager.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/5.
//

#import <Foundation/Foundation.h>
#import "HKFloatBall.h"

@interface WARFloatWindowManager : NSObject

+ (instancetype)shared;

@property (nonatomic, strong) HKFloatBall *floatView;

@end
