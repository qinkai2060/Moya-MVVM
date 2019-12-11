//
//  WARJournalListLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/12.
//

#import "WARJournalListLayout.h"
#import "WARMacros.h"
#import "NSString+Size.h"
#import "WARFeedComponentLayout.h"
#import "WARMoment.h"

@interface WARJournalListLayout()

@end

@implementation WARJournalListLayout
 
+ (WARJournalListLayout *)layoutWithMoment:(WARMoment *)moment {
    WARJournalListLayout *layout = [[WARJournalListLayout alloc] init];
    
    layout.moment = moment;
    
#pragma mark - 顶部frame
    /** 顶部frame */
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = kScreenWidth;
    CGFloat topViewH = 70;
    layout.topViewFrame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    
#pragma mark - page frame
    CGFloat feedMainContentViewX = kFeedMainContentLeftMargin;
    CGFloat feedMainContentViewY = kSeparatorH + 10;
    CGFloat feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
    CGFloat feedMainContentViewH = kFeedMainContentViewHeight;
    
    switch (moment.momentShowType) {
        case WARMomentShowTypeUserDiary:
        case WARMomentShowTypeFriendFollow:
        case WARMomentShowTypeFriendFollowDetail:
        case WARMomentShowTypeFriend:{
            if (moment.isMultilPage) {
                //multi page frame
                feedMainContentViewY = kSeparatorH + 15;
            } else {
                //single page frame
                feedMainContentViewX = kFeedMainContentLeftMargin;
                feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
                
//                WARFeedPageModel *pageModel = moment.ironBody.pageContents.firstObject;
//                CGFloat tempHeight = 0;
//                for (WARFeedComponentModel *component in pageModel.components) {
//                    WARFeedComponentLayout *tempLayout = [[WARFeedComponentLayout alloc]init];
//                    tempLayout.contentScale = kContentScale;
//                    tempLayout.momentShowType = WARMomentShowTypeFriend;
//                    [tempLayout setComponent:component];
//                    tempHeight += tempLayout.cellHeight;
//                }
//                feedMainContentViewH = tempHeight;

                /// 全文显示控制
                WARFeedPageModel *pageModel = moment.ironBody.pageContents.firstObject;
                CGFloat tempHeight = 0;
                for (WARFeedComponentModel *component in pageModel.components) {
                    WARFeedComponentLayout *tempLayout = [[WARFeedComponentLayout alloc]init];
                    tempLayout.contentScale = kContentScale;
                    tempLayout.momentShowType = WARMomentShowTypeFriend;
                    [tempLayout setComponent:component];
                    tempHeight += tempLayout.cellHeight;
                    
                    /// 是否显示全文按钮
                    if (tempHeight > (kFeedPageViewMaxHeight) && pageModel.components.count > 1) {
                        moment.isShowAllContextTip = YES;
                        /// 还原
                        tempHeight -= tempLayout.cellHeight;
                        break ;
                    }
                }
                feedMainContentViewH = tempHeight;
            }
            break;
        }
        case WARMomentShowTypeFriendDetail: {
            //detail page frame
            feedMainContentViewX = kFeedMainContentLeftMargin;
            feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
            feedMainContentViewH = moment.journalListLayout.extendPageContentHeight;
            
            break;
        }
        default:{
            
        }
            break;
    }
    
    layout.feedMainContentViewFrame = CGRectMake(feedMainContentViewX, feedMainContentViewY, feedMainContentViewW, feedMainContentViewH);
    
#pragma mark - 底部frame
    CGFloat bottomItemMargin = 12.5;
    CGFloat cellRightMargin = 11.5;
    CGFloat bottomBottomMargin = 14;
    
    /** 底部frame */
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = feedMainContentViewY + feedMainContentViewH;
    CGFloat bottomViewW = kScreenWidth;
    CGFloat bottomViewH = 33;
    
    //地理信息
    CGFloat addressButtonX = kFeedMainContentLeftMargin;
    CGFloat addressButtonY = 8;
    CGFloat addressButtonW = (kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin) * 0.6;
    CGFloat addressButtonH = 12;
    
    CGFloat stepCountButtonX = kFeedMainContentLeftMargin;
    CGFloat stepCountButtonY = 0;
    CGFloat stepCountButtonW = (kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin) * 0.6;
    CGFloat stepCountButtonH = 15;
    
    layout.addressButtonFrame = CGRectMake(addressButtonX, addressButtonY, addressButtonW, addressButtonH);
    
    CGFloat allContextW = 0;
    CGFloat allContextH = 0;
    CGFloat allContextX = 0;
    CGFloat allContextY = 0;
    if (moment.isShowAllContextTip) {
        bottomViewH += 24;
        
        allContextW = 50;
        allContextH = 15.5;
        allContextX = kScreenWidth - kCellContentMargin - allContextW;
        allContextY = 8;
    } else {
        allContextW = 0;
        allContextH = 0;
        allContextX = 0;
        allContextY = 0;
    }
    layout.allContextButtonFrame = CGRectMake(allContextX, allContextY, allContextW, allContextH);
    
    layout.bottomViewFrame = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
     
    /** sendingViewFrame */
    CGFloat sendingViewW = 70;
    CGFloat sendingViewH = 17;
    CGFloat sendingViewX = kFeedMainContentLeftMargin;
    CGFloat sendingViewY = bottomViewH - bottomBottomMargin - sendingViewH + 3;
    layout.sendingViewFrame = CGRectMake(sendingViewX, sendingViewY, sendingViewW, sendingViewH);
    
    /** sendFailFrame */
    CGFloat sendFailViewW = 106;
    CGFloat sendFailViewH = 17;
    CGFloat sendFailViewX = kFeedMainContentLeftMargin;
    CGFloat sendFailViewY = bottomViewH - bottomBottomMargin - sendFailViewH + 3;;
    layout.sendFailFrame = CGRectMake(sendFailViewX, sendFailViewY, sendFailViewW, sendFailViewH);
    
    //评论
    if (moment.commentWapper.commentCount <= 0) {
        CGFloat commentW = 17;
        CGFloat commentH = 17;
        CGFloat commentX = kScreenWidth - cellRightMargin - commentW;
        CGFloat commentY = bottomViewH - bottomBottomMargin - commentH + 3;
        layout.commentButtonFrame = CGRectMake(commentX, commentY, commentW, commentH);
        
        //点赞
        CGFloat praiseW = 17;
        CGFloat praiseH = 17;
        CGFloat praiseX = commentX - bottomItemMargin - praiseW;
        CGFloat praiseY = commentY;
        if (moment.commentWapper.praiseCount <= 0) {
            layout.praiseButtonFrame = CGRectMake(praiseX, praiseY, praiseW, praiseH);
        } else {
            NSString *praise = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount];
            CGFloat praiseCountW = [praise widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:12];
            praiseW = praiseW + praiseCountW + 3.5;
            praiseX = praiseX - praiseCountW - 3.5;
            layout.praiseButtonFrame = CGRectMake(praiseX , praiseY, praiseW, praiseH);
        }
    } else {
        //评论
        NSString *comment = [[NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount];
        CGFloat commentCountW = [comment widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:12];
        
        CGFloat commentW = 17 + commentCountW + 3.5;
        CGFloat commentH = 17;
        CGFloat commentX = kScreenWidth - cellRightMargin - commentW;
        CGFloat commentY = bottomViewH - bottomBottomMargin - commentH + 3;
        layout.commentButtonFrame = CGRectMake(commentX, commentY, commentW, commentH);
        
        //点赞
        CGFloat praiseW = 17;
        CGFloat praiseH = 17;
        CGFloat praiseX = commentX - bottomItemMargin - praiseW;
        CGFloat praiseY = commentY;
        if (moment.commentWapper.praiseCount <= 0) {
            layout.praiseButtonFrame = CGRectMake(praiseX, praiseY, praiseW, praiseH);
        } else {
            NSString *praise = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount];
            CGFloat praiseCountW = [praise widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:12];
            praiseW = praiseW + praiseCountW + 3.5;
            praiseX = commentX - bottomItemMargin - praiseW;
            
        }
        layout.praiseButtonFrame = CGRectMake(praiseX, praiseY, praiseW, praiseH);
    }
    layout.cellHeight = MAX((bottomViewY + bottomViewH), topViewH);
    
    return layout;
}

/**
 日志列表布局 （2018-07-30）
 根据 isDisplyPage 字段判断是否多页展示
 @param moment moment
 @return 布局
 */
+ (WARJournalListLayout *)journalListLayoutWithMoment:(WARMoment *)moment {
    WARJournalListLayout *layout = [[WARJournalListLayout alloc] init];
    layout.moment = moment;
    
#pragma mark - 顶部frame
    /** 顶部frame */
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = kScreenWidth;
    CGFloat topViewH = 70;
    layout.topViewFrame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    
#pragma mark - page frame
    CGFloat feedMainContentViewX = kFeedMainContentLeftMargin;
    CGFloat feedMainContentViewY = kSeparatorH + 10;
    CGFloat feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
    CGFloat feedMainContentViewH = kFeedMainContentViewHeight;
    
    switch (moment.momentShowType) {
            case WARMomentShowTypeUserDiary:
            case WARMomentShowTypeFriendFollow:
            case WARMomentShowTypeFriendFollowDetail:
            case WARMomentShowTypeFriend:{
                if (moment.isMultilPage) {
                    //multi page frame
                    feedMainContentViewY = kSeparatorH + 15;
                } else {
                    //single page frame
                    feedMainContentViewX = kFeedMainContentLeftMargin;
                    feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
                    /// 全文显示控制
                    WARFeedPageModel *pageModel = moment.ironBody.pageContents.firstObject;
                    CGFloat tempHeight = 0;
                    if(moment.ironBody.pageContents.count > 1){ /// 多个 pageContents 元素
                        for (WARFeedComponentModel *component in pageModel.components) {
                            WARFeedComponentLayout *tempLayout = [[WARFeedComponentLayout alloc]init];
                            tempLayout.contentScale = kContentScale;
                            tempLayout.momentShowType = WARMomentShowTypeFriend;
                            [tempLayout setComponent:component];
                            tempHeight += tempLayout.cellHeight;
                        }
                        /// 是否显示全文按钮
                        moment.isShowAllContextTip = YES;
                        
                    } else { /// 只有一个 pageContents 元素
                        for (WARFeedComponentModel *component in pageModel.components) {
                            WARFeedComponentLayout *tempLayout = [[WARFeedComponentLayout alloc]init];
                            tempLayout.contentScale = kContentScale;
                            tempLayout.momentShowType = WARMomentShowTypeFriend;
                            [tempLayout setComponent:component];
                            tempHeight += tempLayout.cellHeight;
                            /// 是否显示全文按钮
                            if (tempHeight > (kFeedPageViewMaxHeight) && pageModel.components.count > 1) {
                                moment.isShowAllContextTip = YES;
                                /// 还原
                                tempHeight -= tempLayout.cellHeight;
                                break ;
                            }
                        }
                    } 
                    feedMainContentViewH = tempHeight;
                }
                break;
            }
            case WARMomentShowTypeFriendDetail: {
                //detail page frame
                feedMainContentViewX = kFeedMainContentLeftMargin;
                feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
                feedMainContentViewH = moment.journalListLayout.extendPageContentHeight;
                
                break;
            }
        default:{
        }
            break;
    }
    layout.feedMainContentViewFrame = CGRectMake(feedMainContentViewX, feedMainContentViewY, feedMainContentViewW, feedMainContentViewH);
    
#pragma mark - 底部frame
    CGFloat bottomItemMargin = 12.5;
    CGFloat cellRightMargin = 11.5;
    CGFloat bottomBottomMargin = 14;
    
    /** 底部frame */
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = feedMainContentViewY + feedMainContentViewH;
    CGFloat bottomViewW = kScreenWidth;
    CGFloat bottomViewH = 33;
    
    //地理信息
    CGFloat addressButtonX = kFeedMainContentLeftMargin;
    CGFloat addressButtonY = 8;
    CGFloat addressButtonW = (kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin) * 0.6;
    CGFloat addressButtonH = 12;
    
    CGFloat stepCountButtonX = kFeedMainContentLeftMargin;
    CGFloat stepCountButtonY = 0;
    CGFloat stepCountButtonW = (kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin) * 0.6;
    CGFloat stepCountButtonH = 15;
    
    layout.addressButtonFrame = CGRectMake(addressButtonX, addressButtonY, addressButtonW, addressButtonH);
    
    CGFloat allContextW = 0;
    CGFloat allContextH = 0;
    CGFloat allContextX = 0;
    CGFloat allContextY = 0;
    if (moment.isShowAllContextTip) {
        bottomViewH += 24;
        
        allContextW = 50;
        allContextH = 15.5;
        allContextX = kScreenWidth - kCellContentMargin - allContextW;
        allContextY = 8;
    } else {
        allContextW = 0;
        allContextH = 0;
        allContextX = 0;
        allContextY = 0;
    }
    layout.allContextButtonFrame = CGRectMake(allContextX, allContextY, allContextW, allContextH);
    layout.bottomViewFrame = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    
    /** sendingViewFrame */
    CGFloat sendingViewW = 70;
    CGFloat sendingViewH = 17;
    CGFloat sendingViewX = kFeedMainContentLeftMargin;
    CGFloat sendingViewY = bottomViewH - bottomBottomMargin - sendingViewH + 3;
    layout.sendingViewFrame = CGRectMake(sendingViewX, sendingViewY, sendingViewW, sendingViewH);
    
    /** sendFailFrame */
    CGFloat sendFailViewW = 106;
    CGFloat sendFailViewH = 17;
    CGFloat sendFailViewX = kFeedMainContentLeftMargin;
    CGFloat sendFailViewY = bottomViewH - bottomBottomMargin - sendFailViewH + 3;;
    layout.sendFailFrame = CGRectMake(sendFailViewX, sendFailViewY, sendFailViewW, sendFailViewH);
    
    //评论
    if (moment.commentWapper.commentCount <= 0) {
        CGFloat commentW = 17;
        CGFloat commentH = 17;
        CGFloat commentX = kScreenWidth - cellRightMargin - commentW;
        CGFloat commentY = bottomViewH - bottomBottomMargin - commentH + 3;
        layout.commentButtonFrame = CGRectMake(commentX, commentY, commentW, commentH);
        
        //点赞
        CGFloat praiseW = 17;
        CGFloat praiseH = 17;
        CGFloat praiseX = commentX - bottomItemMargin - praiseW;
        CGFloat praiseY = commentY;
        if (moment.commentWapper.praiseCount <= 0) {
            layout.praiseButtonFrame = CGRectMake(praiseX, praiseY, praiseW, praiseH);
        } else {
            NSString *praise = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount];
            CGFloat praiseCountW = [praise widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:12];
            praiseW = praiseW + praiseCountW + 3.5;
            praiseX = praiseX - praiseCountW - 3.5;
            layout.praiseButtonFrame = CGRectMake(praiseX , praiseY, praiseW, praiseH);
        }
    } else {
        //评论
        NSString *comment = [[NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount];
        CGFloat commentCountW = [comment widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:12];
        
        CGFloat commentW = 17 + commentCountW + 3.5;
        CGFloat commentH = 17;
        CGFloat commentX = kScreenWidth - cellRightMargin - commentW;
        CGFloat commentY = bottomViewH - bottomBottomMargin - commentH + 3;
        layout.commentButtonFrame = CGRectMake(commentX, commentY, commentW, commentH);
        
        //点赞
        CGFloat praiseW = 17;
        CGFloat praiseH = 17;
        CGFloat praiseX = commentX - bottomItemMargin - praiseW;
        CGFloat praiseY = commentY;
        if (moment.commentWapper.praiseCount <= 0) {
            layout.praiseButtonFrame = CGRectMake(praiseX, praiseY, praiseW, praiseH);
        } else {
            NSString *praise = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount];
            CGFloat praiseCountW = [praise widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:12];
            praiseW = praiseW + praiseCountW + 3.5;
            praiseX = commentX - bottomItemMargin - praiseW;
            
        }
        layout.praiseButtonFrame = CGRectMake(praiseX, praiseY, praiseW, praiseH);
    }
    layout.cellHeight = MAX((bottomViewY + bottomViewH), topViewH);
    
    return layout;
}

#pragma mark - 日志详情 page展开总高度
- (void)setFeedLayoutArr:(NSMutableArray<WARFeedPageLayout *> *)feedLayoutArr {
    _feedLayoutArr = feedLayoutArr;
    _extendPageContentHeight = 0;
    for (WARFeedPageLayout *pageLayout in _feedLayoutArr) {
        _extendPageContentHeight += pageLayout.diaryContentHeight;
    }
}

#pragma mark - 限制页数
- (NSMutableArray <WARFeedPageLayout *>*)limitFeedLayoutArr{
    return _limitFeedLayoutArr;
}

#pragma mark - 当前页index
- (NSInteger)currentPageIndex{
    return _currentPageIndex;
}

@end
