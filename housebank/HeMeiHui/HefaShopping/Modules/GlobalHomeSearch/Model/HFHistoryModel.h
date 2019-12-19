//
//  HFHistoryModel.h
//  HeMeiHui
//
//  Created by usermac on 2019/4/19.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HFHistoryModel : NSObject
@property(nonatomic,copy)NSString *historyStr;
@property(nonatomic,copy)NSArray<HFHistoryModel*> *dataSource;
@end

NS_ASSUME_NONNULL_END
