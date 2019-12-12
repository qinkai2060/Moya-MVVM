//
//  WARJournalListLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import <Foundation/Foundation.h>
#import "WARFeedModelProtocol.h"
@class WARFeedPageLayout,WARMoment;

@interface WARJournalListLayout : NSObject<WARFeedModelProtocol>

/**
 日志列表布局 （2018-07-30 以前）

 @param moment moment
 @return 布局
 */
+ (WARJournalListLayout *)layoutWithMoment:(WARMoment *)moment;

/**
 日志列表布局 （2018-07-30）
 根据 isDisplyPage 字段判断是否多页展示
 @param moment moment
 @return 布局
 */
+ (WARJournalListLayout *)journalListLayoutWithMoment:(WARMoment *)moment;

/** moment */
@property (nonatomic, weak) WARMoment *moment;
/** 内容布局 */
@property (nonatomic, strong) NSMutableArray <WARFeedPageLayout *>* feedLayoutArr;
/** 多页时最多展示3页 */
@property (nonatomic, strong) NSMutableArray <WARFeedPageLayout *>* limitFeedLayoutArr;
/** Description */
@property (nonatomic, assign) NSInteger currentPageIndex;
/** 日志详情 page展开总高度 */
@property (nonatomic, assign) CGFloat extendPageContentHeight;

#pragma mark - frame
@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) CGRect topViewFrame;

@property (nonatomic, assign) CGRect textContentLableFrame;
@property (nonatomic, assign) CGRect feedMainContentViewFrame;

@property (nonatomic, assign) CGRect addressButtonFrame;
@property (nonatomic, assign) CGRect allContextButtonFrame;
@property (nonatomic, assign) CGRect praiseButtonFrame;
@property (nonatomic, assign) CGRect commentButtonFrame;
@property (nonatomic, assign) CGRect sendingViewFrame;
@property (nonatomic, assign) CGRect sendFailFrame;
@property (nonatomic, assign) CGRect bottomViewFrame;
 
@end
