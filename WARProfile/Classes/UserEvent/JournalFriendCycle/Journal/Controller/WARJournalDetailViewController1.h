//
//  WARJournalDetailViewController1.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/17.
//

#import "WARBaseViewController.h"

@class WARMoment;

@interface WARJournalDetailViewController1 : WARBaseViewController

- (instancetype)initWithMoment:(WARMoment *)moment;
- (instancetype)initWithMomentId:(NSString *)momentId friendId:(NSString *)friendId;

@end

@interface WARMultiPageTableView:UITableView

@end
