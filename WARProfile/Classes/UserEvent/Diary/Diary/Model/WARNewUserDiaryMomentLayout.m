//
//  WARNewUserDiaryMomentLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/4/28.
//

#import "WARNewUserDiaryMomentLayout.h"
#import "WARNewUserDiaryModel.h"
#import "WARMacros.h"
#import "NSString+Size.h"
#import "WARFeedComponentLayout.h"

#define kSeparatorH 0.5

@implementation WARNewUserDiaryMomentLayout

- (void)setMoment:(WARNewUserDiaryMoment *)moment {
    _moment = moment;
     
    CGFloat cellHeight = 0;
    
#pragma mark - 顶部frame
    /** 顶部frame */
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = kScreenWidth;
    CGFloat topViewH = 70;
    _topViewFrame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    cellHeight = cellHeight + topViewH;
    
#pragma mark - page frame
    CGFloat feedMainContentViewX = kFeedMainContentLeftMargin;
    CGFloat feedMainContentViewY = kSeparatorH + 15;
    CGFloat feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
    CGFloat feedMainContentViewH = kFeedMainContentViewHeight;
    
    switch (moment.momentShowType) {
        case WARMomentShowTypeUserDiary:
        case WARMomentShowTypeFriendFollow:
        case WARMomentShowTypeFriendFollowDetail:
        case WARMomentShowTypeFriend:{
            if (moment.pageContents.count == 1) {
                //single page frame
                feedMainContentViewX = kFeedMainContentLeftMargin;
                feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
                
                WARFeedPageModel *pageModel = moment.pageContents.firstObject;
                CGFloat tempHeight = 0;
                for (WARFeedComponentModel *component in pageModel.components) {
                    WARFeedComponentLayout *tempLayout = [[WARFeedComponentLayout alloc]init];
                    tempLayout.contentScale = kContentScale;
                    tempLayout.momentShowType = WARMomentShowTypeUserDiary;
                    [tempLayout setComponent:component];
                    tempHeight += tempLayout.cellHeight;
                }
                feedMainContentViewH = tempHeight;
            } else {
                //page frame
            }
            break;
        }
        case WARMomentShowTypeFriendDetail: {
            //detail page frame
            feedMainContentViewX = kFeedMainContentLeftMargin;
            feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
            feedMainContentViewH = moment.momentLayout.extendPageContentHeight;
            
            break;
        }
        default:{
            
        }
            break;
    }
    
    _feedMainContentViewFrame = CGRectMake(feedMainContentViewX, feedMainContentViewY, feedMainContentViewW, feedMainContentViewH);
    
    cellHeight = cellHeight + feedMainContentViewH;
    
#pragma mark - 底部frame
    /** 底部frame */
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = feedMainContentViewY + feedMainContentViewH;
    CGFloat bottomViewW = kScreenWidth;
    CGFloat bottomViewH = 40;
    
    //地理信息
    CGFloat addressButtonX = kFeedMainContentLeftMargin;
    CGFloat addressButtonY = 0;
    CGFloat addressButtonW = (kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin) * 0.6;
    CGFloat addressButtonH = 12;
    
    CGFloat stepCountButtonX = kFeedMainContentLeftMargin;
    CGFloat stepCountButtonY = 0;
    CGFloat stepCountButtonW = (kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin) * 0.6;
    CGFloat stepCountButtonH = 15;
    if (moment.location == nil || moment.location.length <= 0) {
        //地理信息
        _addressButtonFrame = CGRectZero;
        //步数
        if (moment.stepNum <= 0) {
            _stepCountButtonFrame = CGRectZero;
        }
        _stepCountButtonFrame = CGRectMake(stepCountButtonX, stepCountButtonY, stepCountButtonW, stepCountButtonH);
        
        bottomViewH = 40;
    } else {
        //地理信息
        _addressButtonFrame = CGRectMake(addressButtonX, addressButtonY, addressButtonW, addressButtonH);
        //步数
        if (moment.stepNum <= 0) {
            _stepCountButtonFrame = CGRectZero;
            
            bottomViewH = 40;
        } else {
            stepCountButtonY = 12 + _addressButtonFrame.size.height + 5;  
        }
        _stepCountButtonFrame = CGRectMake(stepCountButtonX, stepCountButtonY, stepCountButtonW, stepCountButtonH);
    }
    _bottomViewFrame = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    
    //评论
    CGFloat bottomItemMargin = 14;
    CGFloat cellLeftRightMargin = 13;
    CGFloat bottomTopMargin = 10;
    //...
    CGFloat moreW = 22;
    CGFloat moreH = 17;
    CGFloat moreX = kScreenWidth - cellLeftRightMargin - moreW;
    CGFloat moreY = bottomTopMargin;
    if (moment.commentCount <= 0) {
        CGFloat commentW = 17;
        CGFloat commentH = 17;
        CGFloat commentX = kScreenWidth - cellLeftRightMargin - commentW;
        CGFloat commentY = bottomTopMargin;
        _commentButtonFrame = CGRectMake(commentX, commentY, commentW, commentH);
        
        //点赞
        CGFloat praiseW = 17;
        CGFloat praiseH = 17;
        CGFloat praiseX = commentX - bottomItemMargin - praiseW;;
        CGFloat praiseY = bottomTopMargin;
        if (moment.praiseCount <= 0) {
            _praiseButtonFrame = CGRectMake(praiseX, praiseY, praiseW, praiseH);
        } else {
            CGFloat praiseCountW = [[NSString stringWithFormat:@"%ld",moment.praiseCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
            _praiseButtonFrame = CGRectMake(praiseX - praiseCountW - 3, bottomTopMargin, praiseW, praiseH);
        }
    } else {
        //评论
        CGFloat commentCountW = [[NSString stringWithFormat:@"%ld",moment.commentCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
        
        CGFloat commentW = 17;
        CGFloat commentH = 17;
        CGFloat commentX = kScreenWidth - cellLeftRightMargin - commentW - commentCountW - 3;
        CGFloat commentY = bottomTopMargin;
        _commentButtonFrame = CGRectMake(commentX, commentY, commentW, commentH);
        
        //点赞
        CGFloat praiseW = 17;
        CGFloat praiseH = 17;
        CGFloat praiseX = commentX - bottomItemMargin - praiseW;
        CGFloat praiseY = bottomTopMargin;
        if (moment.praiseCount <= 0) {
            _praiseButtonFrame = CGRectMake(praiseX, praiseY, praiseW, praiseH);
        } else {
            CGFloat praiseCountW = [[NSString stringWithFormat:@"%ld",moment.praiseCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
            praiseX = commentX - bottomItemMargin - praiseW - praiseCountW - 3;
        }
        _praiseButtonFrame = CGRectMake(praiseX, praiseY, praiseW, praiseH);
    }
    cellHeight = cellHeight + bottomViewH;
    
    _cellHeight = bottomViewY + bottomViewH;
}

- (void)setFeedLayoutArr:(NSMutableArray<WARFeedPageLayout *> *)feedLayoutArr {
    _feedLayoutArr = feedLayoutArr;
    _extendPageContentHeight = 0;
    for (WARFeedPageLayout *pageLayout in _feedLayoutArr) {
        _extendPageContentHeight += pageLayout.diaryContentHeight;
    }
}
 

- (NSInteger)currentPageIndex{
    return _currentPageIndex;
}

@end
