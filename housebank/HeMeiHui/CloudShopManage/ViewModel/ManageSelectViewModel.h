//
//  ManageSelectViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/11.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXViewModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ManageSelectViewModel : NSObject <JXViewModelProtocol>
@property (nonatomic, strong) RACSubject *refreshUISubject;
@property (nonatomic, copy)  NSString * shopID;
- (RACSignal *)loadRequest_product_list:(NSString *)shopID;
- (RACSignal *)loadMore_productList:(NSString *)shopID;
- (RACSignal *)putAway_selectShop:(NSString *)shopId productArray:(NSArray*)productArray;
@end

NS_ASSUME_NONNULL_END
