//
//  WARSimpleStoreOrHotelLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import <Foundation/Foundation.h>
#import "WARFeedStore.h"

@interface WARSimpleStoreOrHotelLayout : NSObject
/** store */
@property (nonatomic, strong) WARFeedStore *store;

+ (WARSimpleStoreOrHotelLayout *)simpleStoreLayout:(WARFeedStore *)store;

@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGRect scoreFrame;
@property (nonatomic, assign) CGRect priceFrame;
@property (nonatomic, assign) CGRect locationFrame;

@end
