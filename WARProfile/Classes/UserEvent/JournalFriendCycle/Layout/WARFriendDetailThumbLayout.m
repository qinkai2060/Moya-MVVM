//
//  WARFriendDetailThumbLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/15.
//

#import "WARFriendDetailThumbLayout.h"
#import "WARThumbModel.h"
#import "WARMacros.h"

#define kSeparatorH 0.5
#define kCellMargin 11.5
#define kLikeLableLeftLikeIconWidthAndMargin 33
#define kLikeLableRightMargin 8

@implementation WARFriendDetailThumbLayout

+ (WARFriendDetailThumbLayout *)layoutWithThumb:(WARThumbModel *)thumb {
    WARFriendDetailThumbLayout *layout = [[WARFriendDetailThumbLayout alloc] init];
    
    //点赞用户视图frame
    CGFloat likeViewX = kCellMargin;
    CGFloat likeViewY = 15;
    CGFloat likeViewW = kScreenWidth - 2 * kCellMargin;
    CGFloat likeViewH = 0;
    if (thumb.thumbUserBos.count > 0) {
         
        //likeLabelFrame
        CGFloat likeLabelX = 0;
        CGFloat likeLabelY = 0;
        CGFloat likeLabelW = likeViewW;
        
        CGFloat likeContentHeight = [thumb.noIconThumbUsersAttributedContent boundingRectWithSize:CGSizeMake(likeLabelW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
        likeViewH += likeContentHeight;
        
        CGFloat likeLabelH = likeViewH;
        
        layout.likeLabelFrame = CGRectMake(likeLabelX, likeLabelY, likeLabelW, likeLabelH);
        //likeLableBottomLineFrame
        layout.likeLableBottomLineFrame = CGRectMake(0, likeViewH + 10 - kSeparatorH, likeViewW, kSeparatorH);
    } else {
        likeViewH = 0;
    }
    layout.likeViewFrame = CGRectMake(likeViewX, likeViewY, likeViewW, likeViewH);
    
    layout.cellHeight = likeViewH + 30;
    
    return layout;
}

@end
