//
//  HFDataModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/21.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFDataModel : NSObject
/**
 cashPrice = 868;
 firstClassifyName = "\U76f4\U4f9b\U7cbe\U54c1";
 imageUrl = "/user/community/1529901195/phm15jh0wcwr07q2.jpg";
 jointPictrue = " ";
 productId = 38095;
 productLevel = 1;
 productName = "\U76d7\U9f84\U79d8\U5236\U53c2200g\Uff0850g*4\U652f\Uff09\U5f00\U888b\U5373\U98df \U4e94\U5e74\U4eba\U53c2 \U591a\U79cd\U5403\U6cd5";
 productSubtitle = "";
 secondClassifyName = "\U76f4\U4f9b\U7cbe\U54c1";
 shopId = 173;
 shopName = "\U9006\U9f84\U4ea7\U54c1\U65d7\U8230\U5e97";
 singleProductState = 0;
 specificationsId = 66425;
 stock = 539;
 thirdClassifyName = "\U76f4\U4f9b\U7cbe\U54c1";
 */
@property(nonatomic,assign)NSInteger productId;
@property(nonatomic,assign)NSInteger famousProudctId;
@property(nonatomic,assign)NSInteger shopId;
@property(nonatomic,assign)NSInteger productLevel;
@property(nonatomic,assign)NSInteger singleProductState;
@property(nonatomic,assign)NSInteger specificationsId;
@property(nonatomic,assign)NSInteger stock;
@property(nonatomic,assign)CGFloat cashPrice;

@property(nonatomic,strong)NSString *firstClassifyName;
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,strong)NSString *jointPictrue;
@property(nonatomic,strong)NSString *productName;
@property(nonatomic,strong)NSString *shopName;
@property(nonatomic,strong)NSString *productSubtitle;
@property(nonatomic,strong)NSString *tag;
@property(nonatomic,strong)NSString *thirdClassifyName;
@property(nonatomic,strong)NSString *secondClassifyName;
@property(nonatomic,assign)BOOL useRegisterCoupon;
- (void)getDataObj:(id)obj;
@end

NS_ASSUME_NONNULL_END
