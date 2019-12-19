//
//  HFSpecialPriceOneModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFSpecialPriceOneModel : HFHomeBaseModel
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *littleTitle;
@property(nonatomic,copy)NSString *tagStr;
@property(nonatomic,copy)NSString *colorStr;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,copy)NSString *link;
//@property(nonatomic,copy)NSArray *spArray;
//@property(nonatomic,copy)NSString *linkMappType;
@end

NS_ASSUME_NONNULL_END
