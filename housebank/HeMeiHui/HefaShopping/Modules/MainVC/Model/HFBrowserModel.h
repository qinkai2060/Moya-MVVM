//
//  HFBrowserModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class HFBrowserSmallModel;
@interface HFBrowserModel : HFHomeBaseModel
//@property(nonatomic,strong)NSArray<HFBrowserSmallModel*> *dataArray;
@property(nonatomic,strong)NSString *linkUrl;
@property(nonatomic,strong)NSString *imgUrl;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,assign)NSInteger index;

@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSString *goodsId;
@property(nonatomic,strong)NSString *describe;
@end
@interface HFBrowserSmallModel:NSObject
@property(nonatomic,strong)NSString *linkUrl;

@end

NS_ASSUME_NONNULL_END
