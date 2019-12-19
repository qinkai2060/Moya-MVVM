//
//  HFNewsModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFNewsModel : HFHomeBaseModel
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *url;
//@property(nonatomic,strong)NSArray *dataSource;
//@property(nonatomic,copy)NSString *linkMapingId;
//@property(nonatomic,copy)NSString *linkMapingType;

@end

NS_ASSUME_NONNULL_END
