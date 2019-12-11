//
//  WARMomentModel.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "WARMoment.h"

@interface WARMomentModel : NSObject

@property (nonatomic, copy) NSString *lastFindId;
@property (nonatomic, copy) NSString *searchSort;
@property (nonatomic, copy) NSString *lastPublishTime;
@property (nonatomic, copy) NSArray <WARMoment *> *moments;

@end
