//
//  HFFashionModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFFashionModel : HFHomeBaseModel
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *littleTitle;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,copy)NSString *imgUrl_2;
@property(nonatomic,copy)NSString *link;

@property(nonatomic,copy)NSString *goodsId;
//@property(nonatomic,copy)NSString *mainTitle;
//@property(nonatomic,copy)NSString *subtitle;
//@property(nonatomic,copy)NSArray *fashionArray;
//@property(nonatomic,copy)NSString *linkMappingType;
@end

NS_ASSUME_NONNULL_END
