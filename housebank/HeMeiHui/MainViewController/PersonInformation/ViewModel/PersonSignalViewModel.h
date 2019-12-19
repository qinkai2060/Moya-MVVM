//
//  PersonSignalViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PersonSignalViewModel : NSObject
- (RACSignal *)getRequestPersonInfo;

- (RACSignal *)changePersonIndoWithParams:(NSDictionary*)params;

- (RACSignal *)getIphoneToSendWithNumber:(NSString *)phone areacode:(NSString *)areacode;

// 上传图片
- (RACSignal *)sendPostUSerHeadImage;
@end

NS_ASSUME_NONNULL_END
