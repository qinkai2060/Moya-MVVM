//
//  WARLightPlayVideoCellLayout.m
//  WARProfile
//
//  Created by 卧岚科技 on 2018/6/28.
//

#import "WARLightPlayVideoCellLayout.h"
#import "WARRecommendVideo.h"
#import "WARMacros.h"
#import "NSString+Size.h"

@implementation WARLightPlayVideoCellLayout

+ (WARLightPlayVideoCellLayout *)layoutWithVideo:(WARRecommendVideo *)video {
    WARLightPlayVideoCellLayout *layout = [[WARLightPlayVideoCellLayout alloc]init];
    layout.video = video;
    
    CGFloat coverImageW = kScreenWidth;
    CGFloat coverImageH = AdaptedWidth(210.5);
    CGFloat coverImageX = 0;
    CGFloat coverImageY = 0;
    layout.coverImageViewFrame = CGRectMake(coverImageX, coverImageY, coverImageW, coverImageH);
    
    CGFloat playBtnW = 58;
    CGFloat playBtnH = 58;
    CGFloat playBtnX = (CGRectGetWidth(layout.coverImageViewFrame)-playBtnW) * 0.5;
    CGFloat playBtnY = (CGRectGetHeight(layout.coverImageViewFrame)-playBtnH) * 0.5;
    layout.playBtnFrame = CGRectMake(playBtnX, playBtnY, playBtnW, playBtnH); 
    
    CGFloat titleLabelX = 13;
    CGFloat titleLabelY = coverImageY + coverImageH + 7.5;
    CGFloat titleLabelW = kScreenWidth - 26;
    CGFloat tempTitleLabelH = [video.desc heightWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15] constrainedToWidth:titleLabelW];
    CGFloat titleLabelH = tempTitleLabelH  > 48 ? 48 : tempTitleLabelH;
    layout.titleLabelFrame = CGRectMake(titleLabelX, titleLabelY, titleLabelW, titleLabelH);
    
    CGFloat userImageW = 36;
    CGFloat userImageH = 36;
    CGFloat userImageX = titleLabelX;
    CGFloat userImageY = titleLabelY + titleLabelH + 8;
    layout.userImageViewFrame = CGRectMake(userImageX, userImageY, userImageW, userImageH);
    
    CGFloat nameLabelW = kScreenWidth * 0.5;
    CGFloat nameLabelH = 16;
    CGFloat nameLabelX = userImageX + userImageW + 12;
    CGFloat nameLabelY = userImageY + (userImageH - nameLabelH) * 0.5;
    layout.nameLabelFrame = CGRectMake(nameLabelX, nameLabelY, nameLabelW, nameLabelH);
    
    CGFloat commentBtnW = 17;
    NSString *commentString = [[NSString stringWithFormat:@"%ld",video.commentWapper.commentCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",video.commentWapper.commentCount];
    if (commentString && commentString.length > 0) {
        commentBtnW += [commentString widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:17] + 3;
    }
    CGFloat commentBtnH = 17;
    CGFloat commentBtnX = kScreenWidth - commentBtnW - 13;
    CGFloat commentBtnY = nameLabelY;
    layout.commentBtnFrame = CGRectMake(commentBtnX, commentBtnY, commentBtnW, commentBtnH);
    
    CGFloat likeBtnW = 17;
    NSString *likeString = [[NSString stringWithFormat:@"%ld",video.commentWapper.praiseCount] isEqualToString:@"0"] ? @"" : [NSString stringWithFormat:@"%ld",video.commentWapper.praiseCount];
    if (likeString && likeString.length > 0) {
        likeBtnW += [likeString widthWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:12] constrainedToHeight:17] + 3;
    }
    CGFloat likeBtnH = 17;
    CGFloat likeBtnX = kScreenWidth - commentBtnW - likeBtnW - 25;
    CGFloat likeBtnY = nameLabelY;
    layout.likeBtnFrame = CGRectMake(likeBtnX, likeBtnY, likeBtnW, likeBtnH);
    
    layout.maskViewRect = CGRectMake(0, 0, kScreenWidth, CGRectGetMaxY(layout.userImageViewFrame) + 16);
    
    layout.cellHeight = CGRectGetMaxY(layout.maskViewRect);
    layout.isVerticalVideo = NO;
    
    
    return layout;
}

@end
