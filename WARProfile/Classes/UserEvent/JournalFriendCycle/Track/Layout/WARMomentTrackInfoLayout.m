//
//  WARMomentTrackInfoLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/20.
//

#import "WARMomentTrackInfoLayout.h"

#import "WARMacros.h"
#import "WARFeedMacro.h"

@implementation WARMomentTrackInfoLayout

/**
 根据足迹信息生成布局
 
 @param traceInfo 足迹信息
 @return WARMomentTrackInfoView 布局
 */
+ (WARMomentTrackInfoLayout *)layoutWithTraceInfo:(WARMomentTraceInfo *)traceInfo {
    WARMomentTrackInfoLayout *layout = [[WARMomentTrackInfoLayout alloc]init];
    layout.traceInfo = traceInfo;
    
    CGFloat contentW = kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin;
    CGFloat contentH = 66;
    
    /// shareF
    CGFloat shareW = 45;
    CGFloat shareH = 20;
    CGFloat shareX = contentW - shareW;
    CGFloat shareY = 0;
    layout.shareF = CGRectMake(shareX, shareY, shareW, shareH);
    
    /// activitionF
    CGFloat activitionW = 45;
    CGFloat activitionH = 20;
    CGFloat activitionX = contentW - activitionW - 10;
    CGFloat activitionY = 35.5;
    layout.activitionF = CGRectMake(activitionX, activitionY, activitionW, activitionH);
    
    /// mainTitleF
    CGFloat mainTitleX = 10;
    CGFloat mainTitleY = 14;
    CGFloat mainTitleW = contentW - 2 * mainTitleX;
    CGFloat mainTitleH = 15;
    layout.mainTitleF = CGRectMake(mainTitleX, mainTitleY, mainTitleW, mainTitleH);
    
    /// locationF
    CGFloat locationX = mainTitleX;
    CGFloat locationY = mainTitleY + mainTitleH + 9.5;
    CGFloat locationW = mainTitleW;
    CGFloat locationH = 13;
    switch (traceInfo.trackType) {
        case WARMomentTrackTypeMine:
        case WARMomentTrackTypeOther:
        {
            locationW = contentW - 2 * locationX;
        }
            break;
        case WARMomentTrackTypeActivation:
        {
            locationW = contentW - 2 * locationX - activitionW - 20;
        }
            break;
    }
    layout.locationF = CGRectMake(locationX, locationY, locationW, locationH);
    
    
    return layout;
}

@end
