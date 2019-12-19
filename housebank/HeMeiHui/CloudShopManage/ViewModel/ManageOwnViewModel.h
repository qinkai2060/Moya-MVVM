//
//  ManageOwnViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXViewModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageOwnViewModel : NSObject <JXViewModelProtocol>
@property (nonatomic, strong) RACSubject *refreshUISubject;
@property (nonatomic, copy)  NSString * shopID;
- (RACSignal *)loadRequest_sellDataWithShopID:(NSString *)shopID Type:(NSString *)type pageNo:(NSInteger)pageNo;
- (RACSignal *)loadMore_sellDataWithShopID:(NSString *)shopID Type:(NSString *)type pageNo:(NSInteger)pageNo;
- (RACSignal *)down_selectShop:(NSString *)shopId productArray:(nonnull NSArray *)productArray;
- (RACSignal *)putAway_selectShop:(NSString *)shopId productArray:(nonnull NSArray *)productArray;
- (RACSignal *)TopShopWithProductID:(NSString *)productID;
- (RACSignal *)loadRequest_shareTheOrederWithProductID:(NSString *)productID;
@end

NS_ASSUME_NONNULL_END
