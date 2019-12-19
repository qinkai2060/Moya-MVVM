//
//  SpikeTimeListModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/3/28.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "SetBaseModel.h"
#import <YYKit/YYKit.h>
//@protocol SpikeTimesItem
//
//@end
NS_ASSUME_NONNULL_BEGIN

//@interface SpikeTimesItem :JSONModel
//@property (nonatomic , assign) NSInteger              activityId;
//@property (nonatomic , copy) NSString              * timeParagraph;
//@property (nonatomic , assign) NSInteger              state;
//@property (nonatomic , assign) NSInteger              productId;
//
//@end


@interface SpikeTime :NSObject<NSCoding>
@property (nonatomic , strong) NSArray <NSDictionary *>              * times;

@end


@interface SpikeTimeListModel :SetBaseModel
@property (nonatomic , strong) SpikeTime              * data;

@end


NS_ASSUME_NONNULL_END

