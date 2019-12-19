//
//  TopContactsModel.h
//  HeMeiHui
//
//  Created by 张磊 on 2019/4/29.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopContactsModel : NSObject
@property (nonatomic, strong) NSString *topContactsId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
@end

NS_ASSUME_NONNULL_END
