//
//  WARFollowDetailViewController.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/8.
//

#import "WARCommentsBaseViewController.h"

@class WARCMessageModel,WARMoment;

@interface WARFollowDetailViewController : WARCommentsBaseViewController

- (instancetype)initCommentsVCWithItemId:(NSString *)itemId scrollToComment:(BOOL)scrollToComment;

- (void)configMoment:(WARMoment *)moment;

@property (nonatomic, strong) WARCMessageModel *repliedMessage;

@end


