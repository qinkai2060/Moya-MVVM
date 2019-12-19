//
//  HFDBManger.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/22.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
NS_ASSUME_NONNULL_BEGIN

@interface HFDBManger : NSObject
@property(nonatomic,strong)FMDatabaseQueue *queue;
+ (HFDBManger *)sharedDBManager;
@end

NS_ASSUME_NONNULL_END
