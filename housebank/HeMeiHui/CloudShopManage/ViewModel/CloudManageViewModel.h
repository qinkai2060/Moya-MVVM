//
//  CloudManageViewModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/5.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXViewModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, shopTypes) {
    haveWeiShop,
    NoWeiShop,
};

@interface CloudManageViewModel : NSObject <JXViewModelProtocol>
@property (nonatomic, strong) RACSubject * refreshUISubject;
@property (nonatomic, assign) shopTypes shopTypes;
- (RACSignal *)loadRequest_ShopList;
/** 判断店铺类型*/
- (shopTypes)judgeShopTypes;
- (RACSignal *)create_shopQrcode:(NSString *)shopID shopType:(NSString *)shopType; 
@end

NS_ASSUME_NONNULL_END
