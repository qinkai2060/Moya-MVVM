//
//  HFAddressModel.h
//  housebank
//
//  Created by usermac on 2018/11/20.
//  Copyright © 2018 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFAddressModel : NSObject
@property (nonatomic,strong) NSString *ids;
@property (nonatomic,strong) NSString *blockId;
@property (nonatomic,strong) NSString *regionId;
@property (nonatomic,strong) NSString *cityId;
@property (nonatomic,strong) NSString *townId;
@property (nonatomic,strong) NSString *receiptName;
@property (nonatomic,strong) NSString *completeAddress;
@property (nonatomic,strong) NSString *detailAddress;
@property (nonatomic,strong) NSString *partAddress;
@property (nonatomic,strong) NSString *zipCode;
@property (nonatomic,strong) NSString *receiptPhone;


@property (nonatomic,copy) NSString *cityName;
@property (nonatomic,copy) NSString *regionName;
@property (nonatomic,copy) NSString *blockName;
@property (nonatomic,copy) NSString *townName;
@property (nonatomic,assign) BOOL defalutAddress;
@property (nonatomic,assign) CGFloat rowheght;
@property (nonatomic,assign)  NSInteger fromeSource;
- (void)getDict:(NSDictionary*)dictData;
@end

NS_ASSUME_NONNULL_END
