//
//  WARFriendDetailViewController.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/7.
//

#import "WARBaseViewController.h"
@class WARMoment;

@interface WARFriendDetailViewController : WARBaseViewController

- (instancetype)initWithMoment:(WARMoment *)moment type:(NSString *)type;

@end
