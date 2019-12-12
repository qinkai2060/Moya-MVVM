//
//  WARMomentRemindModel.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import <Foundation/Foundation.h>
#import "WARMomentRemind.h"
#import "WARFriendMessageLayout.h"

@interface WARMomentRemindModel : NSObject
/** refId */
@property (nonatomic, copy) NSString *refId;
/** messages */
@property (nonatomic, strong) NSMutableArray<WARMomentRemind *> *reminds;

/** 辅助字段 */
/** layouts */
@property (nonatomic, strong) NSMutableArray<WARFriendMessageLayout *> *layouts;
@end
