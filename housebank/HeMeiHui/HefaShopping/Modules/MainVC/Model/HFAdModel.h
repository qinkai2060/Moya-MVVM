//
//  HFAdModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFAdModel : HFHomeBaseModel
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *title;
//@property(nonatomic,copy)NSArray *adDataArray;
//@property(nonatomic,copy)NSString *linkMappingID;
//@property(nonatomic,copy)NSString *linkMappingType;
@end

NS_ASSUME_NONNULL_END
