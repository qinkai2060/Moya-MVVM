//
//  WARNewUserDiaryMomentLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/4/28.
//

#import "WARFriendMomentLayout.h"
#import "WARMoment.h"
#import "WARDBContactModel.h"
#import "WARMacros.h"
#import "NSString+Size.h"
#import "WARFeedComponentLayout.h"
#import "NSString+AttributedString.h"
#import "WARFriendCommentLayout.h"

static CGFloat kWARFriendCellTopViewHeight = 56;
static CGFloat kWARFriendCellBottomViewHeight = 39.5 + kSeparatorH;
 
@implementation WARFriendMomentLayout

/** 详情页布局 */
- (void)setMoment:(WARMoment *)moment {
    _moment = moment;
    
    CGFloat cellHeight = 0;
    
#pragma mark - 顶部frame
    /** 顶部frame */
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = kScreenWidth;
    CGFloat topViewH = kWARFriendCellTopViewHeight;
    _topViewFrame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    cellHeight = cellHeight + topViewH;
    
    //userImage
    CGFloat userImageX = kCellContentMargin;
    CGFloat userImageY = 14;
    CGFloat userImageW = kUserImageWidthHeight;
    CGFloat userImageH = kUserImageWidthHeight;
    _userImageFrame = CGRectMake(userImageX, userImageY, userImageW, userImageH);
    
    //nameLable
    CGFloat nameLableX = userImageX + userImageW + kUserImageContentMargin;
    CGFloat nameLableY = 16.5;
    CGFloat nameLableH = 16;
    CGFloat nameLableW = [[NSString stringWithFormat:@"%@",moment.friendModel.nickname] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] constrainedToHeight:nameLableH];
    _nameLableFrame = CGRectMake(nameLableX, nameLableY, nameLableW, nameLableH);
     
    //ageImage
    CGFloat ageImageX = nameLableX + nameLableW + AdaptedWidth(4.5);
    CGFloat ageImageY = nameLableY + 1.5;
    CGFloat ageImageW = 13;
    CGFloat ageImageH = 13;
    _ageImageFrame = CGRectMake(ageImageX, ageImageY, ageImageW, ageImageH);
    
    //sexImage
    CGFloat sexImageX = ageImageX + ageImageW + AdaptedWidth(2.5);
    CGFloat sexImageY = nameLableY + 1.5;
    CGFloat sexImageW = 13;
    CGFloat sexImageH = 13;
    _sexImageFrame = CGRectMake(sexImageX, sexImageY, sexImageW, sexImageH);
    
    //extendButton
    CGFloat extendButtonW = 28;
    CGFloat extendButtonH = 33;
    CGFloat extendButtonX = kScreenWidth - AdaptedWidth(9) - extendButtonW;
    CGFloat extendButtonY = 12;
    _extendButtonFrame = CGRectMake(extendButtonX, extendButtonY, extendButtonW, extendButtonH);
    
#pragma mark - page frame
    CGFloat feedMainContentViewX = kFeedMainContentLeftMargin;//AdaptedWidth(3);
    CGFloat feedMainContentViewY = nameLableY + nameLableH + 9;
    CGFloat feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
    CGFloat feedMainContentViewH = kFeedMainContentViewHeight;
    
    switch (moment.momentShowType) { 
        case WARMomentShowTypeFriendFollowDetail:
        case WARMomentShowTypeFriendDetail:
        case WARMomentShowTypeUserDiary:
        case WARMomentShowTypeFriendFollow:
        case WARMomentShowTypeFriend:
        case WARMomentShowTypeMapProfile:{
            if (moment.isMultilPage) {
                //page frame
                
            } else {
                //single page frame
                feedMainContentViewX = kFeedMainContentLeftMargin;
                feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
                
                WARFeedPageModel *pageModel = moment.ironBody.pageContents.firstObject;
                CGFloat tempHeight = 0;
                for (WARFeedComponentModel *component in pageModel.components) {
                    WARFeedComponentLayout *tempLayout = [[WARFeedComponentLayout alloc]init];
                    tempLayout.contentScale = kContentScale;
                    tempLayout.momentShowType = WARMomentShowTypeFriend;
                    [tempLayout setComponent:component];
                    tempHeight += tempLayout.cellHeight;
                }
                feedMainContentViewH = tempHeight;
            }
            break;
        } 
        case WARMomentShowTypeFullText:{
            feedMainContentViewX = 13;
            feedMainContentViewY = 10.5;
            feedMainContentViewW = kScreenWidth - 26;
            feedMainContentViewH = moment.friendMomentLayout.extendPageContentHeight;
        }
            break;
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
    CGFloat bottomViewH = 45;
    
    CGFloat addressX = kFeedMainContentLeftMargin;
    CGFloat addressY = 8;
    CGFloat addressW = bottomViewW * 0.5;
    CGFloat addressH = 11;
    //地理信息
    if (moment.location == nil || moment.location.length <= 0) {
        _addressButtonFrame = CGRectZero;
        
        bottomViewH = kWARFriendCellBottomViewHeight - addressH - 7.5 ;
    } else {
        _addressButtonFrame = CGRectMake(addressX, addressY, addressW, addressH);
        bottomViewH = kWARFriendCellBottomViewHeight;
    }
    _bottomViewFrame = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    _bottomSeparatorFrame = CGRectMake(bottomViewX, bottomViewY - kSeparatorH, bottomViewW, kSeparatorH);
    
    //timeLable
    CGFloat timeLableW = kScreenWidth * 0.5;
    CGFloat timeLableH = 12;
    CGFloat timeLableX = kFeedMainContentLeftMargin;
    CGFloat timeLableY = bottomViewH - timeLableH ;
//    if (_addressButtonFrame.size.height == 0) {
//        timeLableY = bottomViewH - timeLableH - 5;
//    }
    _timeLableFrame = CGRectMake(timeLableX, timeLableY, timeLableW, timeLableH);
    
    //评论按钮
    CGFloat commentW = 17;
    CGFloat commentH = 17;
    CGFloat commentX = bottomViewW - commentW - kCellContentMargin;
    CGFloat commentY = timeLableY - 2.5;
    
    //去评论按钮
    _toCommentButtonFrame = CGRectMake( commentX, commentY, commentW, commentH);
    
    //点赞按钮
    CGFloat praiseButtonX = 0;
    CGFloat praiseButtonY = commentY;
    CGFloat praiseButtonW = 17;
    CGFloat praiseButtonH = 17;
    if (moment.commentWapper.commentCount <= 0) {
        //评论
        _commentButtonFrame = CGRectMake( commentX, commentY, commentW, commentH);
        //点赞
        if (moment.commentWapper.praiseCount <= 0) {
            praiseButtonX = commentX - praiseButtonW - 12;
        } else {
            CGFloat praiseCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
            
            praiseButtonW = praiseCountW + praiseButtonW + 3;
            praiseButtonX = commentX - praiseButtonW - 12;
        }
        _praiseButtonFrame = CGRectMake(praiseButtonX, praiseButtonY, praiseButtonW, praiseButtonH);
    } else {
        //评论
        CGFloat commentCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
        commentW = commentW + commentCountW + 3;
        commentX = bottomViewW - commentW - 12;
        
        _commentButtonFrame = CGRectMake(commentX, commentY, commentW, commentH);
        //点赞
        if (moment.commentWapper.praiseCount <= 0) {
            praiseButtonX = bottomViewW - commentW - praiseButtonW - 12;
        } else {
            CGFloat praiseCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
            praiseButtonW = praiseButtonW + praiseCountW + 3;
            praiseButtonX = bottomViewW - commentW - praiseButtonW - 12;
        }
        _praiseButtonFrame = CGRectMake(praiseButtonX, praiseButtonY, praiseButtonW, praiseButtonH);
    }
    _detailCellHeight = bottomViewY + bottomViewH;
    
    //点赞用户视图frame
    CGFloat likeViewX = kCellContentMargin;
    CGFloat likeViewY = bottomViewH + bottomViewY;
    CGFloat likeViewW = kScreenWidth - 2 * kCellContentMargin;
    CGFloat likeViewH = 15;
    if (moment.commentWapper.thumb.thumbUserBos.count > 0) {
        //likeLabelFrame
        CGFloat likeLabelX = 8;
        CGFloat likeLabelY = 5+5;
        CGFloat likeLabelW = likeViewW - 2 * likeLabelX;
        
        CGFloat likeContentHeight = [moment.thumbUsersAttributedContent boundingRectWithSize:CGSizeMake(likeLabelW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        likeViewH += likeContentHeight;
        
        CGFloat likeLabelH = likeViewH - 10 - 5;
        
        _likeLabelFrame = CGRectMake(likeLabelX, likeLabelY, likeLabelW, likeLabelH);
        
        if (moment.commentWapper.comment.comments.count > 0) {
            //likeLableBottomLineFrame
            _likeLableBottomLineFrame = CGRectMake(0, likeViewH - kSeparatorH, likeViewW, kSeparatorH);
        } else {
            //likeLableBottomLineFrame
            _likeLableBottomLineFrame = CGRectMake(0, likeViewH - kSeparatorH, likeViewW, 0);
        }
    } else {
        likeViewH = 0;
    }
    _likeViewFrame = CGRectMake(likeViewX, likeViewY, likeViewW, likeViewH);
    //likeBgImageViewFrame
    _likeBgImageViewFrame = CGRectMake(0, 0, likeViewW, likeViewH);
    
    
    //评论视图frame
    CGFloat commentViewX = kFeedMainContentLeftMargin;
    CGFloat commentViewY = likeViewH + likeViewY;
    CGFloat commentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;;
    CGFloat commentViewH = 0;
    if (moment.commentWapper.comment.comments.count > 0) {
        __block CGFloat commentViewHeight = 0;
        [moment.commentsLayoutArr enumerateObjectsUsingBlock:^(WARFriendCommentLayout * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            commentViewHeight += obj.cellHeight;
        }];
        commentViewH = 0;//commentViewHeight;
    } else {
        commentViewH = 0;
    }
    
    _commentViewFrame = CGRectMake(commentViewX, commentViewY, commentViewW, commentViewH);
    
    //分隔线
    CGFloat separatorX = 0;
    CGFloat separatorY = commentViewY + commentViewH + 10 - kSeparatorH;
    CGFloat separatorW = kScreenWidth;
    CGFloat separatorH = kSeparatorH;
    _separatorFrame = CGRectMake(separatorX, separatorY, separatorW, separatorH);
    
    cellHeight = cellHeight + separatorH;
    _cellHeight = separatorY + separatorH;
}

- (void)setFeedLayoutArr:(NSMutableArray<WARFeedPageLayout *> *)feedLayoutArr {
    _feedLayoutArr = feedLayoutArr;
    _extendPageContentHeight = 0;
    for (WARFeedPageLayout *pageLayout in _feedLayoutArr) {
        _extendPageContentHeight += pageLayout.friendContentHeight;
    }
}

- (NSInteger)currentPageIndex{
    return _currentPageIndex;
}

+ (WARFriendMomentLayout *)type:(NSString *) type
                         moment:(WARMoment *)moment
                       openLike:(BOOL)openLike
                    openComment:(BOOL)openComment {
    WARFriendMomentLayout *layout = [[WARFriendMomentLayout alloc]init];
    layout.moment = moment;
    
    CGFloat cellHeight = 0;
    
#pragma mark - 顶部frame
    /** 顶部frame */
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = kScreenWidth;
    CGFloat topViewH = kWARFriendCellTopViewHeight;
    layout.topViewFrame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    cellHeight = cellHeight + topViewH;
    
    //userImage
    CGFloat userImageX = kCellContentMargin;
    CGFloat userImageY = 14;
    CGFloat userImageW = kUserImageWidthHeight;
    CGFloat userImageH = kUserImageWidthHeight;
    layout.userImageFrame = CGRectMake(userImageX, userImageY, userImageW, userImageH);
    
    //nameLable
    CGFloat nameLableX = userImageX + userImageW + kUserImageContentMargin;
    CGFloat nameLableY = 16.5;
    CGFloat nameLableH = 16;
    CGFloat nameLableW = [[NSString stringWithFormat:@"%@",moment.friendModel.nickname] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] constrainedToHeight:nameLableH];
    if (nameLableW >= 128) {
        nameLableW = 128;
    }
    layout.nameLableFrame = CGRectMake(nameLableX, nameLableY, nameLableW, nameLableH);
    
    //thirdImageFrame
    CGFloat thirdImageX = nameLableX + nameLableW + AdaptedWidth(6);
    CGFloat thirdImageY = nameLableY;
    CGFloat thirdImageW = 16;
    CGFloat thirdImageH = 16;
    layout.thirdImageFrame = CGRectMake(thirdImageX, thirdImageY, thirdImageW, thirdImageH);
    
    //thirdPlatformNameFrame
    CGFloat thirdPlatformNameX = thirdImageX + thirdImageW + AdaptedWidth(3);
    CGFloat thirdPlatformNameY = nameLableY + 2;
    CGFloat thirdPlatformNameH = 12;
    CGFloat thirdPlatformNameW = 30;//[[NSString stringWithFormat:@"%@",moment.friendModel.nickname] widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:thirdPlatformNameH];;
    layout.thirdPlatformNameFrame = CGRectMake(thirdPlatformNameX, thirdPlatformNameY, thirdPlatformNameW, thirdPlatformNameH);
    
    //ageImage
    CGFloat ageImageX = nameLableX + nameLableW + AdaptedWidth(4.5);
    CGFloat ageImageY = nameLableY + 1.5;
    CGFloat ageImageW = 13;
    CGFloat ageImageH = 13;
    layout.ageImageFrame = CGRectMake(ageImageX, ageImageY, ageImageW, ageImageH);
    
    //sexImage
    CGFloat sexImageX = ageImageX + ageImageW + AdaptedWidth(2.5);
    CGFloat sexImageY = nameLableY + 1.5;
    CGFloat sexImageW = 13;
    CGFloat sexImageH = 13;
    layout.sexImageFrame = CGRectMake(sexImageX, sexImageY, sexImageW, sexImageH);
    
    //platformContainerViewFrame
    CGFloat platformContainerW = (13 + 5) * 3;
    CGFloat platformContainerH = 13;
    CGFloat platformContainerX = kScreenWidth - kCellContentMargin - platformContainerW;
    CGFloat platformContainerY = nameLableY;
    layout.platformContainerViewFrame = CGRectMake(platformContainerX, platformContainerY, platformContainerW, platformContainerH);
    
    //extendButton
    CGFloat extendButtonW = 28;
    CGFloat extendButtonH = 22;
    CGFloat extendButtonX = kScreenWidth - AdaptedWidth(9) - extendButtonW;
    CGFloat extendButtonY = 12;
    layout.extendButtonFrame = CGRectMake(extendButtonX, extendButtonY, extendButtonW, extendButtonH);
    
    //followButton
    CGFloat followButtonW = 64.5;
    CGFloat followButtonH = 22;
    CGFloat followButtonX = kScreenWidth - 40 - followButtonW;
    CGFloat followButtonY = 12;
    layout.followButtonFrame = CGRectMake(followButtonX, followButtonY, followButtonW, followButtonH);
    
#pragma mark - page frame
    CGFloat feedMainContentViewX = kFeedMainContentLeftMargin;//AdaptedWidth(3);
    CGFloat feedMainContentViewY = nameLableY + nameLableH + 9;
    CGFloat feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
    CGFloat feedMainContentViewH = kFeedMainContentViewHeight;
    
    switch (moment.momentShowType) {
        case WARMomentShowTypeUserDiary:
        case WARMomentShowTypeFriendFollow:
        case WARMomentShowTypeFriend:{
            if (moment.isMultilPage) {
                //single page frame
                moment.isShowAllContextTip = NO;
            } else {
                //page frame
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
            
            
            if ([type isEqualToString:@"FOLLOW"] && (moment.momentShowType == WARMomentShowTypeFriendFollow)) {
                layout.showLikeView = NO;
                layout.showCommentView = NO;
            } else {
                layout.showLikeView = YES;
                layout.showCommentView = YES;
            }
            
            break;
        }
        case WARMomentShowTypeFriendFollowDetail:
        case WARMomentShowTypeFriendDetail: {
            //detail page frame
            feedMainContentViewX = kFeedMainContentLeftMargin;
            feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
            feedMainContentViewH = moment.friendMomentLayout.extendPageContentHeight;
            
            layout.showLikeView = YES;
            layout.showCommentView = YES;
            break;
        }
        case WARMomentShowTypeFullText:{
            feedMainContentViewX = 13;
            feedMainContentViewW = kScreenWidth - 26;
            feedMainContentViewH = moment.friendMomentLayout.extendPageContentHeight;
            
            layout.showLikeView = NO;
            layout.showCommentView = NO;
        }
            break;
        default:{
            
        }
            break;
    }
    layout.feedMainContentViewFrame = CGRectMake(feedMainContentViewX, feedMainContentViewY, feedMainContentViewW, feedMainContentViewH);
    
    cellHeight = cellHeight + feedMainContentViewH;
    
#pragma mark - 底部frame
    /** 底部frame */
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = feedMainContentViewY + feedMainContentViewH;
    CGFloat bottomViewW = kScreenWidth;
    CGFloat bottomViewH = 40;
    
    //地理信息
    CGFloat addressX = kFeedMainContentLeftMargin;
    CGFloat addressY = 7;
    CGFloat addressW = bottomViewW * 0.5;
    CGFloat addressH = 11;
    if (moment.location == nil || moment.location.length <= 0) {
        layout.addressButtonFrame = CGRectZero;
        bottomViewY = feedMainContentViewY + feedMainContentViewH - 5;
        bottomViewH = kWARFriendCellBottomViewHeight - addressH - 7.5;
    } else {
        layout.addressButtonFrame = CGRectMake(addressX, addressY, addressW, addressH);
        bottomViewY = feedMainContentViewY + feedMainContentViewH - 2;
        bottomViewH = kWARFriendCellBottomViewHeight;
    }
    
    /** 显示全文 */
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
    
    //timeLable
    CGFloat timeLableW = [[NSString stringWithFormat:@"%@",moment.publishTimeString] widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:12];
    CGFloat timeLableH = 12;
    CGFloat timeLableX = kFeedMainContentLeftMargin;
    CGFloat timeLableY = bottomViewH - timeLableH ;
//    if (layout.addressButtonFrame.size.height == 0) {
//        timeLableY = bottomViewH - timeLableH - 5;
//    }
    layout.timeLableFrame = CGRectMake(timeLableX, timeLableY, timeLableW, timeLableH);
    
    //mineContainer
    CGFloat mineContainerW = 100;
    CGFloat mineContainerH = 15;
    CGFloat mineContainerX = timeLableX + timeLableW + 17;
    CGFloat mineContainerY = timeLableY - 5;
    layout.mineContainerFrame = CGRectMake(mineContainerX, mineContainerY, mineContainerW, mineContainerH);
    
    //rewordView
    CGFloat rewordViewW = 0;
    CGFloat rewordViewH = 0;
    CGFloat rewordViewX = timeLableX + timeLableW + 17;
    CGFloat rewordViewY = timeLableY;
    if (moment.reword) {
        rewordViewW = [[NSString stringWithFormat:@"+%@ 经验",moment.reword.rewordVal] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12] constrainedToHeight:15] + 12 + 2 + 10;
        if (moment.reword.rewordTypeEnum == WARMomentRewordTypeKaPian) {
            rewordViewW = [[NSString stringWithFormat:@"卡片",moment.reword.rewordVal] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12] constrainedToHeight:15] + 12 + 2 + 10;
        }
        rewordViewH = 15;
    }
    layout.rewordViewFrame = CGRectMake(rewordViewX, rewordViewY, rewordViewW, rewordViewH);
    layout.rewordValueLableFrame = CGRectMake(14, 0, rewordViewW - 14, rewordViewH);
    
    //评论按钮
    CGFloat commentW = 17;
    CGFloat commentH = 17;
    CGFloat commentX = bottomViewW - commentW - kCellContentMargin;
    CGFloat commentY = timeLableY - 2.5;
    
    //去评论按钮
    layout.toCommentButtonFrame = CGRectMake( commentX, commentY, commentW, commentH);
    
    //点赞按钮
    CGFloat praiseButtonX = 0;
    CGFloat praiseButtonY = commentY;
    CGFloat praiseButtonW = 17;
    CGFloat praiseButtonH = 17;
    if (moment.commentWapper.commentCount <= 0) {
        //评论
        layout.commentButtonFrame = CGRectMake( commentX, commentY, commentW, commentH);
        //点赞
        if (moment.commentWapper.praiseCount <= 0) {
            praiseButtonX = commentX - praiseButtonW - 12;
        } else {
            CGFloat praiseCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
            
            praiseButtonW = praiseCountW + praiseButtonW + 3;
            praiseButtonX = commentX - praiseButtonW - 12;
        }
        layout.praiseButtonFrame = CGRectMake(praiseButtonX, praiseButtonY, praiseButtonW, praiseButtonH);
    } else {
        //评论
        CGFloat commentCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
        commentW = commentW + commentCountW + 3;
        commentX = bottomViewW - commentW - kCellContentMargin;
        
        layout.commentButtonFrame = CGRectMake(commentX, commentY, commentW, commentH);
        //点赞
        if (moment.commentWapper.praiseCount <= 0) {
            praiseButtonX = commentX - praiseButtonW - 12;
        } else {
            CGFloat praiseCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
            praiseButtonW = praiseButtonW + praiseCountW + 3;
            praiseButtonX = commentX - praiseButtonW - 12;//bottomViewW - commentW - praiseButtonW - kCellContentMargin - 7.5;
        }
        layout.praiseButtonFrame = CGRectMake(praiseButtonX, praiseButtonY, praiseButtonW, praiseButtonH);
    }
    
    //向上箭头arrowImageFrame
    CGFloat arrowImageX = kFeedMainContentLeftMargin + 10.5;
    CGFloat arrowImageY = bottomViewH + bottomViewY + 5.5;
    CGFloat arrowImageW = 11;
    CGFloat arrowImageH = 0;
    if (moment.commentWapper.thumb.thumbUserBos.count > 0 || moment.commentWapper.comment.comments.count > 0) { 
        if ([type isEqualToString:@"FOLLOW"]) {
            arrowImageY = bottomViewH + bottomViewY;
            arrowImageH = 0;
        } else {
            arrowImageY = bottomViewH + bottomViewY + 5.5;
            arrowImageH = 5.5;
        }
    } else {
        arrowImageY = bottomViewH + bottomViewY;
        arrowImageH = 0;
    }
    layout.arrowImageFrame = CGRectMake(arrowImageX, arrowImageY, arrowImageW, arrowImageH);
    
    //点赞用户视图frame
    CGFloat likeViewX = kFeedMainContentLeftMargin;
    CGFloat likeViewY = arrowImageH + arrowImageY;
    CGFloat likeViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;;
    CGFloat likeViewH = 10;
    if (moment.commentWapper.thumb.thumbUserBos.count > 0
        ) {
        //likeLabelFrame
        CGFloat likeLabelX = 8;
        CGFloat likeLabelY = 5;
        CGFloat likeLabelW = likeViewW - 2 * likeLabelX;
        
        CGFloat likeContentHeight;
        if (openLike) { //全部展开
            likeContentHeight = [NSString getStringRect:moment.thumbUsersAttributedContent width:likeLabelW height:CGFLOAT_MAX].height;
        } else { //限制数量
            likeContentHeight = [NSString getStringRect:moment.limitThumbUsersAttributedContent width:likeLabelW height:CGFLOAT_MAX].height;
        }
        likeViewH += likeContentHeight;
        
        CGFloat likeLabelH = likeContentHeight;
        
        layout.likeLabelFrame = CGRectMake(likeLabelX, likeLabelY, likeLabelW, likeLabelH);
        if (moment.commentWapper.comment.comments.count > 0) {
            //likeLableBottomLineFrame
            layout.likeLableBottomLineFrame = CGRectMake(0, likeViewH - kSeparatorH, likeViewW, kSeparatorH);
        } else {
            //likeLableBottomLineFrame
            layout.likeLableBottomLineFrame = CGRectMake(0, likeViewH - kSeparatorH, likeViewW, 0);
        }
        
        //喜欢展开收起按钮
        CGFloat extendLikeW = 22;
        CGFloat extendLikeH = 22;
        CGFloat extendLikeX = likeViewW - extendLikeW;
        CGFloat extendLikeY = likeViewH - extendLikeH - 5;
        if (moment.showLikeExtend) {
            layout.extendLikeFrame = CGRectMake(extendLikeX, extendLikeY, extendLikeW, extendLikeH);
        } else {
            layout.extendLikeFrame = CGRectZero;
        }
        
        if (moment.momentShowType == WARMomentShowTypeFriendFollow) {
            likeViewH = 0;
            layout.extendLikeFrame = CGRectZero;
        }
    } else {
        likeViewH = 0;
    }
    
    //关注不展示点赞用户
    if ([type isEqualToString:@"FOLLOW"]) {
        likeViewH = 0;
    }
    
    layout.likeViewFrame = CGRectMake(likeViewX, likeViewY, likeViewW, likeViewH);
    //likeBgImageViewFrame
    layout.likeBgImageViewFrame = CGRectMake(0, 0, likeViewW, likeViewH);
    
    
    //评论视图frame
    CGFloat commentViewX = kFeedMainContentLeftMargin;
    CGFloat commentViewY = likeViewH + likeViewY;
    CGFloat commentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;;
    CGFloat commentViewH = 50;
    if (moment.commentWapper.comment.comments.count > 0) {
        __block CGFloat commentViewHeight = 0;
        [moment.commentsLayoutArr enumerateObjectsUsingBlock:^(WARFriendCommentLayout * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            commentViewHeight += obj.cellHeight;
        }];
        commentViewH = commentViewHeight + 5;
    } else {
        commentViewH = 0;
    }
    
    //关注不展示评论信息
    if ([type isEqualToString:@"FOLLOW"]) {
        commentViewH = 0;
    }
    
    if (moment.momentShowType == WARMomentShowTypeFriendFollow) {
        commentViewH = 0;
    }
    layout.commentViewFrame = CGRectMake(commentViewX, commentViewY, commentViewW, commentViewH);
    
    //分隔线
    CGFloat separatorX = 0;
    CGFloat separatorY = commentViewY + commentViewH  - kSeparatorH;
    if (moment.commentWapper.thumb.thumbUserBos.count > 0 || moment.commentWapper.comment.comments.count > 0) {
        separatorY = separatorY + 14;
    } else {
        separatorY = separatorY + 14;
    }
    CGFloat separatorW = kScreenWidth;
    CGFloat separatorH = kSeparatorH;
    layout.separatorFrame = CGRectMake(separatorX, separatorY, separatorW, separatorH);
    
    cellHeight = cellHeight + separatorH;
    
    layout.cellHeight = separatorY + separatorH;
    
    
    return layout;
}


/**
 地图个人动态列表
 
 @param moment moment
 @return 地图个人动态列表布局
 */
+ (WARFriendMomentLayout *)mapProfileMomentListLayoutWithMoment:(WARMoment *)moment {
    
    WARFriendMomentLayout *layout = [[WARFriendMomentLayout alloc]init];
    layout.moment = moment;
    CGFloat cellHeight = 0;
    
#pragma mark - 顶部frame
    /** 顶部frame */
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = kScreenWidth;
    CGFloat topViewH = kWARFriendCellTopViewHeight;
    layout.topViewFrame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    cellHeight = cellHeight + topViewH;
    
    //userImage
    CGFloat userImageX = kCellContentMargin;
    CGFloat userImageY = 14;
    CGFloat userImageW = kUserImageWidthHeight;
    CGFloat userImageH = kUserImageWidthHeight;
    layout.userImageFrame = CGRectMake(userImageX, userImageY, userImageW, userImageH);
    
    //nameLable
    CGFloat nameLableX = userImageX + userImageW + kUserImageContentMargin;
    CGFloat nameLableY = 16.5;
    CGFloat nameLableH = 16;
    CGFloat nameLableW = [[NSString stringWithFormat:@"%@",moment.friendModel.nickname] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] constrainedToHeight:nameLableH];
    if (nameLableW >= 128) {
        nameLableW = 128;
    }
    layout.nameLableFrame = CGRectMake(nameLableX, nameLableY, nameLableW, nameLableH);
    
    //thirdImageFrame
    CGFloat thirdImageX = nameLableX + nameLableW + AdaptedWidth(6);
    CGFloat thirdImageY = nameLableY;
    CGFloat thirdImageW = 16;
    CGFloat thirdImageH = 16;
    layout.thirdImageFrame = CGRectMake(thirdImageX, thirdImageY, thirdImageW, thirdImageH);
    
    //thirdPlatformNameFrame
    CGFloat thirdPlatformNameX = thirdImageX + thirdImageW + AdaptedWidth(3);
    CGFloat thirdPlatformNameY = nameLableY + 2;
    CGFloat thirdPlatformNameH = 12;
    CGFloat thirdPlatformNameW = 30;
    layout.thirdPlatformNameFrame = CGRectMake(thirdPlatformNameX, thirdPlatformNameY, thirdPlatformNameW, thirdPlatformNameH);
    
    //ageImage
    CGFloat ageImageX = nameLableX + nameLableW + AdaptedWidth(4.5);
    CGFloat ageImageY = nameLableY + 1.5;
    CGFloat ageImageW = 13;
    CGFloat ageImageH = 13;
    layout.ageImageFrame = CGRectMake(ageImageX, ageImageY, ageImageW, ageImageH);
    
    //sexImage
    CGFloat sexImageX = ageImageX + ageImageW + AdaptedWidth(2.5);
    CGFloat sexImageY = nameLableY + 1.5;
    CGFloat sexImageW = 13;
    CGFloat sexImageH = 13;
    layout.sexImageFrame = CGRectMake(sexImageX, sexImageY, sexImageW, sexImageH);
    
    //platformContainerViewFrame
    CGFloat platformContainerW = (13 + 5) * 3;
    CGFloat platformContainerH = 13;
    CGFloat platformContainerX = kScreenWidth - kCellContentMargin - platformContainerW;
    CGFloat platformContainerY = nameLableY;
    layout.platformContainerViewFrame = CGRectMake(platformContainerX, platformContainerY, platformContainerW, platformContainerH);
    
    //extendButton
    CGFloat extendButtonW = 28;
    CGFloat extendButtonH = 22;
    CGFloat extendButtonX = kScreenWidth - AdaptedWidth(9) - extendButtonW;
    CGFloat extendButtonY = 12;
    layout.extendButtonFrame = CGRectMake(extendButtonX, extendButtonY, extendButtonW, extendButtonH);
    
    //followButton
    CGFloat followButtonW = 64.5;
    CGFloat followButtonH = 22;
    CGFloat followButtonX = kScreenWidth - 40 - followButtonW;
    CGFloat followButtonY = 12;
    layout.followButtonFrame = CGRectMake(followButtonX, followButtonY, followButtonW, followButtonH);
    
#pragma mark - page frame
    CGFloat feedMainContentViewX = kFeedMainContentLeftMargin;//AdaptedWidth(3);
    CGFloat feedMainContentViewY = nameLableY + nameLableH + 9;
    CGFloat feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
    CGFloat feedMainContentViewH = kFeedMainContentViewHeight;
    if (moment.isMultilPage) {
        //single page frame
        moment.isShowAllContextTip = NO;
    } else {
        //page frame
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

    layout.showLikeView = NO;
    layout.showCommentView = NO;
    
    layout.feedMainContentViewFrame = CGRectMake(feedMainContentViewX, feedMainContentViewY, feedMainContentViewW, feedMainContentViewH);
    
    cellHeight = cellHeight + feedMainContentViewH;
    
#pragma mark - 底部frame
    /** 底部frame */
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = feedMainContentViewY + feedMainContentViewH;
    CGFloat bottomViewW = kScreenWidth;
    CGFloat bottomViewH = 40;
    
    CGFloat addressX = kFeedMainContentLeftMargin;
    CGFloat addressY = 7;
    CGFloat addressW = bottomViewW * 0.5;
    CGFloat addressH = 11;
    //地理信息
    if (moment.location == nil || moment.location.length <= 0) {
        layout.addressButtonFrame = CGRectZero;
        bottomViewY = feedMainContentViewY + feedMainContentViewH - 5;
        bottomViewH = kWARFriendCellBottomViewHeight - addressH - 7.5;
    } else {
        layout.addressButtonFrame = CGRectMake(addressX, addressY, addressW, addressH);
        bottomViewY = feedMainContentViewY + feedMainContentViewH - 2;
        bottomViewH = kWARFriendCellBottomViewHeight;
    }
    layout.bottomViewFrame = CGRectMake(bottomViewX, bottomViewY, bottomViewW, bottomViewH);
    
    //timeLable
    CGFloat timeLableW = [[NSString stringWithFormat:@"%@",moment.publishTimeString] widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:12];
    CGFloat timeLableH = 12;
    CGFloat timeLableX = kFeedMainContentLeftMargin;
    CGFloat timeLableY = bottomViewH - timeLableH ;
    layout.timeLableFrame = CGRectMake(timeLableX, timeLableY, timeLableW, timeLableH);
    
    //mineContainer
    CGFloat mineContainerW = 100;
    CGFloat mineContainerH = 15;
    CGFloat mineContainerX = timeLableX + timeLableW + 17;
    CGFloat mineContainerY = timeLableY - 5;
    layout.mineContainerFrame = CGRectMake(mineContainerX, mineContainerY, mineContainerW, mineContainerH);
    
    //rewordView
    CGFloat rewordViewW = 0;
    CGFloat rewordViewH = 0;
    CGFloat rewordViewX = timeLableX + timeLableW + 17;
    CGFloat rewordViewY = timeLableY;
    if (moment.reword) {
        rewordViewW = [[NSString stringWithFormat:@"+%@ 经验",moment.reword.rewordVal] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12] constrainedToHeight:15] + 12 + 2 + 10;
        if (moment.reword.rewordTypeEnum == WARMomentRewordTypeKaPian) {
            rewordViewW = [[NSString stringWithFormat:@"卡片",moment.reword.rewordVal] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12] constrainedToHeight:15] + 12 + 2 + 10;
        }
        rewordViewH = 15;
    }
    layout.rewordViewFrame = CGRectMake(rewordViewX, rewordViewY, rewordViewW, rewordViewH);
    layout.rewordValueLableFrame = CGRectMake(14, 0, rewordViewW - 14, rewordViewH);
    
    //评论按钮
    CGFloat commentW = 17;
    CGFloat commentH = 17;
    CGFloat commentX = bottomViewW - commentW - kCellContentMargin;
    CGFloat commentY = timeLableY - 2.5;
    
    //去评论按钮
    layout.toCommentButtonFrame = CGRectMake( commentX, commentY, commentW, commentH);
    
    //点赞按钮
    CGFloat praiseButtonX = 0;
    CGFloat praiseButtonY = commentY;
    CGFloat praiseButtonW = 17;
    CGFloat praiseButtonH = 17;
    if (moment.commentWapper.commentCount <= 0) {
        //评论
        layout.commentButtonFrame = CGRectMake( commentX, commentY, commentW, commentH);
        //点赞
        if (moment.commentWapper.praiseCount <= 0) {
            praiseButtonX = commentX - praiseButtonW - 12;
        } else {
            CGFloat praiseCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
            
            praiseButtonW = praiseCountW + praiseButtonW + 3;
            praiseButtonX = commentX - praiseButtonW - 12;
        }
        layout.praiseButtonFrame = CGRectMake(praiseButtonX, praiseButtonY, praiseButtonW, praiseButtonH);
    } else {
        //评论
        CGFloat commentCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
        commentW = commentW + commentCountW + 3;
        commentX = bottomViewW - commentW - kCellContentMargin;
        
        layout.commentButtonFrame = CGRectMake(commentX, commentY, commentW, commentH);
        //点赞
        if (moment.commentWapper.praiseCount <= 0) {
            praiseButtonX = commentX - praiseButtonW - 12;
        } else {
            CGFloat praiseCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
            praiseButtonW = praiseButtonW + praiseCountW + 3;
            praiseButtonX = commentX - praiseButtonW - 12;//bottomViewW - commentW - praiseButtonW - kCellContentMargin - 7.5;
        }
        layout.praiseButtonFrame = CGRectMake(praiseButtonX, praiseButtonY, praiseButtonW, praiseButtonH);
    }
    
    //向上箭头arrowImageFrame
    layout.arrowImageFrame = CGRectZero;
    
    //点赞用户视图frame
    layout.likeViewFrame = CGRectZero;
    //likeBgImageViewFrame
    layout.likeBgImageViewFrame = CGRectZero;
    
    //评论视图frame
    layout.commentViewFrame = CGRectZero;
    
    //分隔线
    CGFloat separatorX = 0;
    CGFloat separatorY = bottomViewH + bottomViewY - kSeparatorH + 14;
    CGFloat separatorW = kScreenWidth;
    CGFloat separatorH = kSeparatorH;
    layout.separatorFrame = CGRectMake(separatorX, separatorY, separatorW, separatorH); 
    
    cellHeight = cellHeight + separatorH;
    
    layout.cellHeight = separatorY + separatorH;
    
    
    return layout;
}


/**
 信息流布局

 @param moment moment
 @return 信息流列表布局
 */
+ (WARFriendMomentLayout *)flowLayoutWithMoment:(WARMoment *)moment {
    WARFriendMomentLayout *layout = [[WARFriendMomentLayout alloc]init];
    layout.moment = moment;
    
    CGFloat cellHeight = 0;
    
#pragma mark - 顶部frame
    /** 顶部frame */
    CGFloat topViewX = 0;
    CGFloat topViewY = 0;
    CGFloat topViewW = kScreenWidth;
    CGFloat topViewH = kWARFriendCellTopViewHeight;
    layout.topViewFrame = CGRectMake(topViewX, topViewY, topViewW, topViewH);
    cellHeight = cellHeight + topViewH;
    
    //userImage
    CGFloat userImageX = kCellContentMargin;
    CGFloat userImageY = 14;
    CGFloat userImageW = kUserImageWidthHeight;
    CGFloat userImageH = kUserImageWidthHeight;
    layout.userImageFrame = CGRectMake(userImageX, userImageY, userImageW, userImageH);
    
    //nameLable
    CGFloat nameLableX = userImageX + userImageW + kUserImageContentMargin;
    CGFloat nameLableY = 16.5;
    CGFloat nameLableH = 16;
    CGFloat nameLableW = [[NSString stringWithFormat:@"%@",moment.friendModel.nickname] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] constrainedToHeight:nameLableH];
    if(moment.momentTypeEnum == WARMomentTypeGroup){
        nameLableW = [[NSString stringWithFormat:@"%@",moment.groupMember.nickname] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:16] constrainedToHeight:nameLableH];
    }
    if (nameLableW >= 128) {
        nameLableW = 128;
    }
    layout.nameLableFrame = CGRectMake(nameLableX, nameLableY, nameLableW, nameLableH);
    
    //thirdImageFrame
    CGFloat thirdImageX = nameLableX + nameLableW + AdaptedWidth(6);
    CGFloat thirdImageY = nameLableY;
    CGFloat thirdImageW = 16;
    CGFloat thirdImageH = 16;
    layout.thirdImageFrame = CGRectMake(thirdImageX, thirdImageY, thirdImageW, thirdImageH);
    
    //thirdPlatformNameFrame
    CGFloat thirdPlatformNameX = thirdImageX + thirdImageW + AdaptedWidth(3);
    CGFloat thirdPlatformNameY = nameLableY + 2;
    CGFloat thirdPlatformNameH = 12;
    CGFloat thirdPlatformNameW = 30;//[[NSString stringWithFormat:@"%@",moment.friendModel.nickname] widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:thirdPlatformNameH];;
    layout.thirdPlatformNameFrame = CGRectMake(thirdPlatformNameX, thirdPlatformNameY, thirdPlatformNameW, thirdPlatformNameH);
    
    //ageImage
    CGFloat ageImageX = nameLableX + nameLableW + AdaptedWidth(4.5);
    CGFloat ageImageY = nameLableY + 1.5;
    CGFloat ageImageW = 13;
    CGFloat ageImageH = 13;
    layout.ageImageFrame = CGRectMake(ageImageX, ageImageY, ageImageW, ageImageH);
    
    //sexImage
    CGFloat sexImageX = ageImageX + ageImageW + AdaptedWidth(2.5);
    CGFloat sexImageY = nameLableY + 1.5;
    CGFloat sexImageW = 13;
    CGFloat sexImageH = 13;
    layout.sexImageFrame = CGRectMake(sexImageX, sexImageY, sexImageW, sexImageH);
    
    //platformContainerViewFrame
    CGFloat platformContainerW = (13 + 5) * 3;
    CGFloat platformContainerH = 13;
    CGFloat platformContainerX = kScreenWidth - kCellContentMargin - platformContainerW;
    CGFloat platformContainerY = nameLableY;
    layout.platformContainerViewFrame = CGRectMake(platformContainerX, platformContainerY, platformContainerW, platformContainerH);
    
    //extendButton
    CGFloat extendButtonW = 28;
    CGFloat extendButtonH = 22;
    CGFloat extendButtonX = kScreenWidth - AdaptedWidth(9) - extendButtonW;
    CGFloat extendButtonY = 12;
    layout.extendButtonFrame = CGRectMake(extendButtonX, extendButtonY, extendButtonW, extendButtonH);
    
    //followButton
    CGFloat followButtonW = 64.5;
    CGFloat followButtonH = 22;
    CGFloat followButtonX = kScreenWidth - 40 - followButtonW;
    CGFloat followButtonY = 12;
    layout.followButtonFrame = CGRectMake(followButtonX, followButtonY, followButtonW, followButtonH);
    
    //adButton
    CGFloat adButtonW = 50;
    CGFloat adButtonH = 20;
    CGFloat adButtonX = kScreenWidth - AdaptedWidth(12) - adButtonW;
    CGFloat adButtonY = 12.5;
//    if(moment.momentShowType){
//        
//    }
    layout.adButtonFrame = CGRectMake(adButtonX, adButtonY, adButtonW, adButtonH);
    
#pragma mark - page frame
    CGFloat feedMainContentViewX = kFeedMainContentLeftMargin;//AdaptedWidth(3);
    CGFloat feedMainContentViewY = nameLableY + nameLableH + 9;
    CGFloat feedMainContentViewW = kScreenWidth - kCellContentMargin - kFeedMainContentLeftMargin;
    CGFloat feedMainContentViewH = kFeedMainContentViewHeight;
    
    if (moment.isMultilPage) {
        //single page frame
        moment.isShowAllContextTip = NO;
    } else {
        //page frame
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
    layout.showLikeView = YES;
    layout.showCommentView = YES;
    layout.feedMainContentViewFrame = CGRectMake(feedMainContentViewX, feedMainContentViewY, feedMainContentViewW, feedMainContentViewH);
    
    cellHeight = cellHeight + feedMainContentViewH;
    
#pragma mark - 底部frame
    /** 底部frame */
    CGFloat bottomViewX = 0;
    CGFloat bottomViewY = feedMainContentViewY + feedMainContentViewH;
    CGFloat bottomViewW = kScreenWidth;
    CGFloat bottomViewH = 40;
    
    //地理信息
    CGFloat addressX = kFeedMainContentLeftMargin;
    CGFloat addressY = 7;
    CGFloat addressW = bottomViewW * 0.5;
    CGFloat addressH = 11;
    if (moment.location == nil || moment.location.length <= 0) {
        layout.addressButtonFrame = CGRectZero;
        bottomViewY = feedMainContentViewY + feedMainContentViewH - 5;
        bottomViewH = kWARFriendCellBottomViewHeight - addressH - 7.5;
    } else {
        layout.addressButtonFrame = CGRectMake(addressX, addressY, addressW, addressH);
        bottomViewY = feedMainContentViewY + feedMainContentViewH - 2;
        bottomViewH = kWARFriendCellBottomViewHeight;
    }
    
    /** 显示全文 */
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
    
    //timeLable
    CGFloat timeLableW = [[NSString stringWithFormat:@"%@",moment.publishTimeString] widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:12];
    CGFloat timeLableH = 12;
    CGFloat timeLableX = kFeedMainContentLeftMargin;
    CGFloat timeLableY = bottomViewH - timeLableH ;
    //    if (layout.addressButtonFrame.size.height == 0) {
    //        timeLableY = bottomViewH - timeLableH - 5;
    //    }
    layout.timeLableFrame = CGRectMake(timeLableX, timeLableY, timeLableW, timeLableH);
    
    //mineContainer
    CGFloat mineContainerW = 100;
    CGFloat mineContainerH = 15;
    CGFloat mineContainerX = timeLableX + timeLableW + 17;
    CGFloat mineContainerY = timeLableY - 5;
    layout.mineContainerFrame = CGRectMake(mineContainerX, mineContainerY, mineContainerW, mineContainerH);
    
    //rewordView
    CGFloat rewordViewW = 0;
    CGFloat rewordViewH = 0;
    CGFloat rewordViewX = timeLableX + timeLableW + 17;
    CGFloat rewordViewY = timeLableY;
    if (moment.reword) {
        rewordViewW = [[NSString stringWithFormat:@"+%@ 经验",moment.reword.rewordVal] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12] constrainedToHeight:15] + 12 + 2 + 10;
        if (moment.reword.rewordTypeEnum == WARMomentRewordTypeKaPian) {
            rewordViewW = [[NSString stringWithFormat:@"卡片",moment.reword.rewordVal] widthWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:12] constrainedToHeight:15] + 12 + 2 + 10;
        }
        rewordViewH = 15;
    }
    layout.rewordViewFrame = CGRectMake(rewordViewX, rewordViewY, rewordViewW, rewordViewH);
    layout.rewordValueLableFrame = CGRectMake(14, 0, rewordViewW - 14, rewordViewH);
    
    //评论按钮
    CGFloat commentW = 17;
    CGFloat commentH = 17;
    CGFloat commentX = bottomViewW - commentW - kCellContentMargin;
    CGFloat commentY = timeLableY - 2.5;
    
    //去评论按钮
    layout.toCommentButtonFrame = CGRectMake( commentX, commentY, commentW, commentH);
    
    //点赞按钮
    CGFloat praiseButtonX = 0;
    CGFloat praiseButtonY = commentY;
    CGFloat praiseButtonW = 17;
    CGFloat praiseButtonH = 17;
    if (moment.commentWapper.commentCount <= 0) {
        //评论
        layout.commentButtonFrame = CGRectMake( commentX, commentY, commentW, commentH);
        //点赞
        if (moment.commentWapper.praiseCount <= 0) {
            praiseButtonX = commentX - praiseButtonW - 12;
        } else {
            CGFloat praiseCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
            
            praiseButtonW = praiseCountW + praiseButtonW + 3;
            praiseButtonX = commentX - praiseButtonW - 12;
        }
        layout.praiseButtonFrame = CGRectMake(praiseButtonX, praiseButtonY, praiseButtonW, praiseButtonH);
    } else {
        //评论
        CGFloat commentCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.commentCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
        commentW = commentW + commentCountW + 3;
        commentX = bottomViewW - commentW - kCellContentMargin;
        
        layout.commentButtonFrame = CGRectMake(commentX, commentY, commentW, commentH);
        //点赞
        if (moment.commentWapper.praiseCount <= 0) {
            praiseButtonX = commentX - praiseButtonW - 12;
        } else {
            CGFloat praiseCountW = [[NSString stringWithFormat:@"%ld",moment.commentWapper.praiseCount] widthWithFont:[UIFont systemFontOfSize:11] constrainedToHeight:15];
            praiseButtonW = praiseButtonW + praiseCountW + 3;
            praiseButtonX = commentX - praiseButtonW - 12;//bottomViewW - commentW - praiseButtonW - kCellContentMargin - 7.5;
        }
        layout.praiseButtonFrame = CGRectMake(praiseButtonX, praiseButtonY, praiseButtonW, praiseButtonH);
    }
    
    //向上箭头arrowImageFrame
    layout.arrowImageFrame = CGRectZero;
    
    //点赞用户视图frame
    layout.likeViewFrame = CGRectZero;
    //likeBgImageViewFrame
    layout.likeBgImageViewFrame = CGRectZero;
    
    //评论视图frame
    layout.commentViewFrame = CGRectZero;
    
    //分隔线
    CGFloat separatorX = 0;
    CGFloat separatorY = bottomViewH + bottomViewY - kSeparatorH + 14;
    CGFloat separatorW = kScreenWidth;
    CGFloat separatorH = kSeparatorH;
    layout.separatorFrame = CGRectMake(separatorX, separatorY, separatorW, separatorH);
    
    cellHeight = cellHeight + separatorH;
    
    layout.cellHeight = separatorY + separatorH;
    
    return layout;
}


@end
