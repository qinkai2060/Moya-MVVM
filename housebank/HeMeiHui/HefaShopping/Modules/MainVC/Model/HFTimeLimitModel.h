//
//  HFTimeLimitModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HFHomeBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class HFTimeLimitSmallModel;
@interface HFTimeLimitModel : HFHomeBaseModel
@property(nonatomic,strong)NSString *hour;
@property(nonatomic,strong)NSString *min;
@property(nonatomic,strong)NSString *second;
@property(nonatomic,assign)NSInteger timersmp;
@property(nonatomic,assign)BOOL isOpentimer;
@property(nonatomic,assign)NSInteger nextActivityTime;
//@property(nonatomic,strong)NSArray *dataArray;
@end
@interface HFTimeLimitSmallModel:NSObject

@property(nonatomic,assign)NSInteger killID;
@property(nonatomic,assign)NSInteger productId;
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *productSubtitle;
@property(nonatomic,copy)NSString *classifications;
@property(nonatomic,copy)NSString *productImage;
@property(nonatomic,assign)NSInteger specificationsId;
@property(nonatomic,assign)NSInteger productLevel;
@property(nonatomic,assign)CGFloat promotionPrice;
@property(nonatomic,copy)NSString *promotionTag;
@property(nonatomic,assign)CGFloat cashPrice;
/*
 "id": 336,
 "productId": 103,
 "productName": "回归测试082340",
 "productSubtitle": "回归测试082340",
 "productImage": "/user/community/1548491020/xd6q6ajzuzewx2wp.jpg",
 "classifications": "1784",
 "specificationsId": 140,
 "cashPrice": 150,
 "promotionPrice": 140,
 "productLevel": null,
 "promotionTag": null
 */
@end
NS_ASSUME_NONNULL_END
