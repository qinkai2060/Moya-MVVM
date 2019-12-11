//
//  WARJournalDetailPublicVC.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/18.
//

#import "WARCommentsBaseViewController.h"
@class WARJournalDetailModel;

@interface WARJournalDetailPublicVC : WARCommentsBaseViewController

- (instancetype)initWithMomentId:(NSString *)momentId friendId:(NSString *)friendId;

/** 详情model */
@property (nonatomic, strong) WARJournalDetailModel *detailModel;

@property (nonatomic, assign) BOOL canScroll;

@end
