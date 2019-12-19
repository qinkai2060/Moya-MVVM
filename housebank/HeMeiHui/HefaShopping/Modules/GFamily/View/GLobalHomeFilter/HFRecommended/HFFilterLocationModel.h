//
//  HFFilterLocationModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFShowFilterModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface HFFilterLocationModel : HFShowFilterModel
@property(nonatomic,assign)NSInteger regionId;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *lat;// 纬度
@property(nonatomic,copy)NSString *lng;// 经度
@property(nonatomic,assign)NSInteger parentId;
+ (HFFilterLocationModel*)locationData;
- (void)getDataDict:(NSDictionary*)dict;
@end

NS_ASSUME_NONNULL_END
