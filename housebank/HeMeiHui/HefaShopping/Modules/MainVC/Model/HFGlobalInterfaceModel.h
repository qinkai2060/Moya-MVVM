//
//  HFGlobalInterfaceModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class HFGlobalInterfaceSmallModel;
@interface HFGlobalInterfaceModel : HFHomeBaseModel
//@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,assign)BOOL isNeedLogin;
@property(nonatomic,copy)NSString *titleImageUrl;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *link;
//@property(nonatomic,copy)NSString *linkMapingId;
//@property(nonatomic,copy)NSString *linkMapingType;
@end

@interface HFGlobalInterfaceSmallModel : NSObject
@property(nonatomic,copy)NSString *titleImageUrl;
@property(nonatomic,copy)NSString *title;

@end
NS_ASSUME_NONNULL_END
