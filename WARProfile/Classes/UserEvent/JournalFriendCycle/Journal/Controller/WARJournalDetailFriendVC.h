//
//  WARJournalDetailFriendVC.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/18.
//

#import "WARBaseViewController.h"
@class WARJournalDetailModel;
@interface WARJournalDetailFriendVC : WARBaseViewController
 
- (instancetype)initWithMomentId:(NSString *)momentId friendId:(NSString *)friendId;

/** 详情model */
@property (nonatomic, strong) WARJournalDetailModel *detailModel;

@property (nonatomic, assign) BOOL canScroll;

@end
