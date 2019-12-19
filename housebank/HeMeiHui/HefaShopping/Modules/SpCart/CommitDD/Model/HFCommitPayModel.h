//
//  HFCommitPayModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/1/23.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFCommitPayModel : NSObject
@property(nonatomic,assign)NSInteger userId;
@property(nonatomic,assign)CGFloat totalPrice;
@property(nonatomic,copy)NSString *shopsImgUrl;
@property(nonatomic,copy)NSString *shopsName;
@property(nonatomic,copy)NSString *orderNo;
- (void)getData:(NSDictionary*)data;
@end

NS_ASSUME_NONNULL_END
