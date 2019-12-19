//
//  CloudCreatWeiShop.h
//  HeMeiHui
//
//  Created by Tracy on 2019/6/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CloudCreatWeiShop : NSObject
- (RACSignal *)creat_WeiShopWithDetailInfo:(NSDictionary *)info;
- (RACSignal *)getSelectAddress:(NSString *)address;
- (RACSignal *)change_WeiShopWithDetailInfo:(NSDictionary *)info;
- (CGFloat)rowHeight:(NSString *)rowOfHeight;
- (UIImage *)addShopImage:(NSString *)shopImageString;
- (RACSignal *)getShop_LogoImage;

@end

NS_ASSUME_NONNULL_END
