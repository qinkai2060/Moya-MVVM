//
//  HFFamousGoodsBannerModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/28.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFFamousGoodsBannerModel : NSObject
@property(nonatomic,copy)NSString *linkContent;
@property(nonatomic,copy)NSString *imageth;
@property(nonatomic,copy)NSString *bannerId;
@property(nonatomic,copy)NSString *advertisingTitle;
@property(nonatomic,assign)NSInteger linkType;
- (void)getData:(NSDictionary*)data;
@end

NS_ASSUME_NONNULL_END
