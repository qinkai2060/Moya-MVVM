//
//  HFCountryCodeModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/29.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFCountryCodeModel : NSObject
@property(nonatomic,strong)NSString *indexKey;
@property(nonatomic,strong)NSString *countryName;
@property(nonatomic,strong)NSString *countryCode;
@property(nonatomic,strong)NSArray *dataArray;
+ (NSArray*)jsonSerialization;
@end

NS_ASSUME_NONNULL_END
