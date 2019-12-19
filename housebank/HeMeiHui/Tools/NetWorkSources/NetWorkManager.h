//
//  NetWorkManager.h
//  HeMeiHui
//
//  Created by Tracy on 2019/11/4.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetWorkManager : NSObject

+(instancetype)shareManager;

- (NSString *)getForKey:(NSString *)key;

@property (nonatomic, copy) NSString *configName;/**< json 文件名，不包含后缀名 */
@end

NS_ASSUME_NONNULL_END
