//
//  WARJournalThumbLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/13.
//

#import "WARJournalThumbLayout.h"
#import "WARThumbModel.h"
#import "WARMacros.h"

#define kSeparatorH 0.5
#define kCellMargin 10
#define kLikeLableLeftLikeIconWidthAndMargin 33
#define kLikeLableRightMargin 8

@implementation WARJournalThumbLayout

+ (WARJournalThumbLayout *)layoutWithThumb:(WARThumbModel *)thumb {
    WARJournalThumbLayout *layout = [[WARJournalThumbLayout alloc] init];
    
    //点赞用户视图frame
    CGFloat likeViewX = kCellMargin;
    CGFloat likeViewY = 0;
    CGFloat likeViewW = kScreenWidth - 2 * kCellMargin;
    CGFloat likeViewH = 0;
    if (thumb.thumbUserBos.count > 0) {
        //likeIconFrame
        CGFloat likeIconX = 13;
        CGFloat likeIconY = 8;
        CGFloat likeIconW = 12;
        CGFloat likeIconH = 11;
        CGRect likeIconFrame = CGRectMake(likeIconX, likeIconY, likeIconW, likeIconH);
        layout.likeIconFrame = likeIconFrame;
        
        //likeLabelFrame
        CGFloat likeLabelX = kLikeLableLeftLikeIconWidthAndMargin;
        CGFloat likeLabelY = 8;
        CGFloat likeLabelW = likeViewW - kLikeLableLeftLikeIconWidthAndMargin - kLikeLableRightMargin;
        
        CGFloat likeContentHeight = [thumb.noIconThumbUsersAttributedContent boundingRectWithSize:CGSizeMake(likeLabelW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        likeViewH += likeContentHeight + 2 * likeLabelY;
        
        CGFloat likeLabelH = likeViewH - 2 * likeLabelY;
        
        layout.likeLabelFrame = CGRectMake(likeLabelX, likeLabelY, likeLabelW, likeLabelH);
        //likeLableBottomLineFrame
        layout.likeLableBottomLineFrame = CGRectMake(0, likeViewH - kSeparatorH, likeViewW, kSeparatorH);
    } else {
        likeViewH = 0;
    }
    layout.likeViewFrame = CGRectMake(likeViewX, likeViewY, likeViewW, likeViewH);
    //likeBgImageViewFrame
    layout.likeBgImageViewFrame = CGRectMake(kCellMargin, 0, likeViewW, likeViewH);
    
    layout.cellHeight = likeViewH;
    
    return layout;
}

@end
