//
//  WARNewUserDiaryMomentLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/4/28.
//

#import <Foundation/Foundation.h>
#import "WARFeedModelProtocol.h"
@class WARNewUserDiaryMoment;

@interface WARNewUserDiaryMomentLayout : NSObject<WARFeedModelProtocol>

/** 使用weak，避免循环引用 */
@property (nonatomic, weak) WARNewUserDiaryMoment *moment;

@property (nonatomic, assign, readonly) CGFloat cellHeight;

//@property (nonatomic, strong) NSMutableArray <WARNewsFeedCommentLayout *>* commentLayoutArr;
@property (nonatomic, strong) NSMutableArray <WARFeedPageLayout *>* feedLayoutArr;
/** 多页时最多展示3页 */
@property (nonatomic, strong) NSMutableArray <WARFeedPageLayout *>* limitFeedLayoutArr;
//@property (nonatomic, strong) NSMutableArray *cardLayoutArr;
/** Description */
@property (nonatomic, assign) NSInteger currentPageIndex;

/** frame */
//@property (nonatomic, assign) CGRect separatorFrame;
//@property (nonatomic, assign) CGRect timeLableFrame;
//@property (nonatomic, assign) CGRect platform1Frame;
//@property (nonatomic, assign) CGRect platform2Frame;
//@property (nonatomic, assign) CGRect platform3Frame;
@property (nonatomic, assign) CGRect topViewFrame;

@property (nonatomic, assign) CGRect textContentLableFrame;
@property (nonatomic, assign) CGRect feedMainContentViewFrame;

@property (nonatomic, assign) CGRect addressButtonFrame;
@property (nonatomic, assign) CGRect praiseButtonFrame;
@property (nonatomic, assign) CGRect commentButtonFrame; 
@property (nonatomic, assign) CGRect stepCountButtonFrame;
@property (nonatomic, assign) CGRect bottomViewFrame;

/** 日志详情 page展开总高度 */
@property (nonatomic, assign) CGFloat extendPageContentHeight;
@end
