//
//  ManageOwnModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageOwnModel : NSObject <JXModelProtocol, NSCoding>
@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString * imgUrl;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * productId;
@property (nonatomic, copy) NSString * productName;
@property (nonatomic, copy) NSString * profit;
@property (nonatomic, copy) NSString * sharerProfitPrice;
@property (nonatomic, assign) BOOL isSelect;
@end

NS_ASSUME_NONNULL_END
