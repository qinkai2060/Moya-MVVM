//
//  WARFeedAlbumLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/25.
//

#import "WARFeedAlbumLayout.h"
#import "WARFeedMacro.h"
#import "WARMacros.h"
#import "NSString+Size.h"

@implementation WARFeedAlbumLayout

+ (WARFeedAlbumLayout *)albumLayout:(WARFeedAlbum *)album {
    WARFeedAlbumLayout *layout = [[WARFeedAlbumLayout alloc] init];
    layout.album = album;
    
    CGFloat coverViewX = kContentLeftMargin;
    CGFloat coverViewY = 0;
    CGFloat coverViewW = kFeedNumber(124);
    CGFloat coverViewH = kFeedNumber(170);
    CGRect coverViewFrame = CGRectMake(coverViewX, coverViewY, coverViewW, coverViewH);
    layout.imageFrame = coverViewFrame;
    
    CGFloat countW = coverViewW;
    CGFloat countH = kFeedNumber(30);
    CGFloat countX = 0 ;
    CGFloat countY = coverViewH - countH;
    CGRect countLableFrame = CGRectMake(countX, countY, countW, countH);
    layout.countFrame = countLableFrame;
    
    CGFloat shadowLayerX = coverViewX ;
    CGFloat shadowLayerY = coverViewY + kFeedNumber(3);
    CGFloat shadowLayerW = coverViewW - kFeedNumber(1.5);
    CGFloat shadowLayerH = coverViewH;
    CGRect shadowLayerFrame = CGRectMake(shadowLayerX, shadowLayerY, shadowLayerW, shadowLayerH);
    layout.shadowLayerFrame = shadowLayerFrame;
    
    CGFloat mainTitleX = kFeedNumber(8);
    CGFloat mainTitleY = shadowLayerY + shadowLayerH + kFeedNumber(6);
    CGFloat mainTitleW = coverViewW - 2 * mainTitleX;
    CGFloat mainTitleH = [album.name heightWithFont:[UIFont fontWithName:@"PingFangSC-Regular" size:kFeedNumber(14)] constrainedToWidth:mainTitleW];
    CGRect mainTitleLableFrame = CGRectMake(mainTitleX, mainTitleY, mainTitleW, mainTitleH);
    layout.titleFrame = mainTitleLableFrame;
    
    layout.contentHeight = CGRectGetMaxY(layout.titleFrame);
    
    return layout;
}

@end
