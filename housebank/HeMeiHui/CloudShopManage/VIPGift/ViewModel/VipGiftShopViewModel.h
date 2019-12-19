//
//  VipGiftShopViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/7/26.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VipGiftShopViewModel : NSObject
@property (nonatomic, strong) NSMutableArray * dataSource;
- (RACSignal *)loadVIP_MoreProductsShow;
- (RACSignal *)loadVIPProductsShow;
/** Vip礼包头部*/
- (RACSignal *)load_requestHeadData;
- (RACSignal *)load_shareRequest;
- (RACSignal *)load_AllRequestData;
@end

NS_ASSUME_NONNULL_END
