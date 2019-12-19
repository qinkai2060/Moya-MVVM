//
//  HFPopupModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/8/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HFPopupModel : HFHomeBaseModel
@property(nonatomic,strong)NSString *imgUrl;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSString *popUpid;
@property(nonatomic,strong)NSString *type;
@end

NS_ASSUME_NONNULL_END
