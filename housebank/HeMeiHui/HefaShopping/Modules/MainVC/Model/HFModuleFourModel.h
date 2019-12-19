//
//  HFModuleFourModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFModuleFourModel : HFHomeBaseModel
@property(nonatomic,copy)NSString *linkUrl;
@property(nonatomic,strong)NSString *imgUrl;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *littleTitle;
@property(nonatomic,strong)NSString *smallTags;
//@property(nonatomic,strong)NSArray *moduleFourArray;
@end

NS_ASSUME_NONNULL_END
