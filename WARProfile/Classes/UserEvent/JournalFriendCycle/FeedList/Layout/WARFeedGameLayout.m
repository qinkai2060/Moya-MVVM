//
//  WARFeedGameLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/3.
//

#import "WARFeedGameLayout.h"
#import "WARFeedMacro.h"
#import "WARMacros.h"
#import "WARFeedModel.h"

@implementation WARFeedGameLayout

+ (WARFeedGameLayout *)gameLayout:(WARFeedGame *)game isMultiPage:(BOOL)isMultiPage{
    
    WARFeedGameLayout *layout = [[WARFeedGameLayout alloc] init];
    game.isMultiPage = isMultiPage;
    layout.game = game;
    
    CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin);
    if (isMultiPage) {
        maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - 13;
    }
    CGSize imgSize = game.media.pintu.viewSizeSize;
    CGFloat bigImageViewX = 5;
    CGFloat bigImageViewY = 5;
    CGFloat bigImageViewW = kLinkContentScale * imgSize.width;
    CGFloat bigImageViewH = kLinkContentScale * imgSize.height;
    CGRect bigImageViewFrame = CGRectMake(bigImageViewX, bigImageViewY, bigImageViewW, bigImageViewH);
    layout.imageFrame = bigImageViewFrame;
    
    CGFloat rankViewX = 5;
    CGFloat rankViewY = bigImageViewY + bigImageViewH + (game.showRank ? (isMultiPage ? kLinkContentScale * 10 : 10) : 5);
    CGFloat rankViewW = maxWidth;
    CGFloat rankViewH = (game.showRank ? (204 + 30) : 0);
    CGRect rankViewFrame = CGRectMake(rankViewX, rankViewY, rankViewW, rankViewH);
    layout.rankViewFrame = rankViewFrame;
    
    layout.contentHeight = rankViewY + rankViewH;
    
    return layout;
}

@end
