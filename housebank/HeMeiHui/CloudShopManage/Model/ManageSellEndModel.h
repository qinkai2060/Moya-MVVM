//
//  ManageSellEndModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/13.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageSellEndModel : NSObject<JXModelProtocol, NSCoding>
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * imgUrl;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * productId;
@property (nonatomic, copy) NSString * productName;
@property (nonatomic, copy) NSString * profit;
@end

NS_ASSUME_NONNULL_END
