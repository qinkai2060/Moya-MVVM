//
//  HFFilterPriceModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/10.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFShowFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFFilterPriceModel : HFShowFilterModel
@property (nonatomic,copy)NSString *selectTitle;
@property (nonatomic,copy)NSString *starSelectTitle;
@property (nonatomic,copy)NSString *minfloat;
@property (nonatomic,copy)NSString *maxfloat;
@property (nonatomic,assign)NSInteger star;
@property (nonatomic,copy)NSString *starSelect;
+ (HFFilterPriceModel*)priceStarData;
+ (HFFilterPriceModel*)priceStarData2;

@end

NS_ASSUME_NONNULL_END
