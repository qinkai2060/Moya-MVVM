//
//  WARSimpleSceneryLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import "WARSimpleSceneryLayout.h"
#import "WARFeedMacro.h"
#import "WARMacros.h"

@implementation WARSimpleSceneryLayout

+ (WARSimpleSceneryLayout *)simpleSceneryLayout:(WARFeedScenery *)scenery {
    WARSimpleSceneryLayout *layout = [[WARSimpleSceneryLayout alloc] init];
    layout.scenery = scenery;
    
    CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - 10;
    
    CGFloat bigImageViewX = 0;
    CGFloat bigImageViewY = 0;
    CGFloat bigImageViewW = kLinkContentScale * 84;
    CGFloat bigImageViewH = bigImageViewW;
    CGRect bigImageViewFrame = CGRectMake(bigImageViewX, bigImageViewY, bigImageViewW, bigImageViewH);
    layout.imageFrame = bigImageViewFrame;
    
    CGFloat mainTitleX = bigImageViewW + 10 * kLinkContentScale;
    CGFloat mainTitleY = 17 * kLinkContentScale;
    CGFloat mainTitleW = maxWidth - 18 * kLinkContentScale;
    CGFloat mainTitleH = 19;
    CGRect mainTitleLableFrame = CGRectMake(mainTitleX, mainTitleY, mainTitleW, mainTitleH);
    layout.titleFrame = mainTitleLableFrame;
    
    CGFloat contentX = mainTitleX;
    CGFloat contentY = mainTitleY + mainTitleH + 14 * kLinkContentScale;
    CGFloat contentW = maxWidth;
    CGFloat contentH = 15;
    CGRect contentLableFrame = CGRectMake(contentX, contentY, contentW, contentH);
    layout.locationFrame = contentLableFrame;
    
    return layout;
}

@end
