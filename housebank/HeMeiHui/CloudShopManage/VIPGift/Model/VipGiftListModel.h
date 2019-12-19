//
//  VipGiftListModel.h
//  HeMeiHui
//
//  Created by Tracy on 2019/7/29.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit/YYKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface VipGiftListModel : NSObject <NSCoding>
@property (nonatomic, copy) NSString * playID;
@property (nonatomic, copy) NSString * videoTitle;
@property (nonatomic, copy) NSString * videoImage;
@property (nonatomic, copy) NSString * videoAddress;
@property (nonatomic, copy) NSString * productId;
@property (nonatomic, strong)NSNumber * videoStatus;
@property (nonatomic, strong)NSNumber * moduleId;
@end

NS_ASSUME_NONNULL_END
