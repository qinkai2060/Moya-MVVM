//
//  WARFeedLinkLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/3.
//

#import "WARFeedLinkLayout.h"
#import "WARFeedModel.h"
#import "WARFeedMedia.h"
#import "WARFeedMacro.h"
#import "WARMacros.h"
#import "NSString+Size.h"

#define kMaxRow 5

@implementation WARFeedLinkLayout

+ (WARFeedLinkLayout *)linkLayout:(WARFeedLinkComponent *)linkComponent {
    WARFeedLinkLayout *linkLayout = [[WARFeedLinkLayout alloc]init];
    linkLayout.linkComponent = linkComponent;
    
    switch (linkComponent.linkType) {
        case WARFeedLinkComponentTypeDefault:
        {
            /** default */
            linkLayout.cellHeight = 84 * kLinkContentScale + 10 * kLinkContentScale;
        }
            break;
        case WARFeedLinkComponentTypeRead:
        {
            linkLayout.cellHeight = 84 * kLinkContentScale + 10 * kLinkContentScale;
        }
            break;
        case WARFeedLinkComponentTypeWeiBo:
        {
            CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - 10;//10是lable在cell中的间距
            CGFloat maxHeight = HUGE;
            
            /// mediaView 宽高计算
            CGFloat mediaViewW = 0;
            CGFloat mediaViewH = 0;
            switch (linkComponent.summaryType) {
                case WARFeedLinkSummaryTypeText:
                {
                    
                }
                    break;
                case WARFeedLinkSummaryTypeVideo:
                {
                    CGFloat videoViewX = 0;
                    CGFloat videoViewY = 0;
                    CGFloat videoViewW = maxWidth;
                    CGFloat videoViewH = maxWidth * 9 / 16;
                    CGRect videoViewFrame = CGRectMake(videoViewX, videoViewY, videoViewW, videoViewH);
                    linkLayout.videoViewFrame = videoViewFrame;
                    
                    mediaViewW = maxWidth;
                    mediaViewH = videoViewH;
                }
                    break;
                case WARFeedLinkSummaryTypeSingleImg:
                {
                    CGFloat bigImageViewX = 0;
                    CGFloat bigImageViewY = 0;
                    CGFloat bigImageViewW = maxWidth;
                    CGFloat bigImageViewH = maxWidth * 9 / 16;
                    CGRect bigImageViewFrame = CGRectMake(bigImageViewX, bigImageViewY, bigImageViewW, bigImageViewH);
                    linkLayout.bigImageViewFrame = bigImageViewFrame;
                    
                    mediaViewW = maxWidth;
                    mediaViewH = bigImageViewH;
                }
                    break;
                case WARFeedLinkSummaryTyperipleImg:
                {
                    CGFloat imageContainerX = 0;
                    CGFloat imageContainerY = 0;
                    CGFloat imageContainerW = maxWidth;
                    CGFloat itemW = (imageContainerW - 2 * 3.5) / 3;
                    CGFloat imageContainerH = itemW * 2 / 3;
                    CGRect imageContainerFrame = CGRectMake(imageContainerX, imageContainerY, imageContainerW, imageContainerH);
                    linkLayout.imageContainerFrame = imageContainerFrame;
                    
                    mediaViewW = maxWidth;
                    mediaViewH = imageContainerH ;
                }
                    break;
            }
            
            /** summary */
            CGFloat mainTitleX = 0;
            CGFloat mainTitleY = 0;
            CGFloat mainTitleW = maxWidth;
            CGFloat mainTitleH = [linkComponent.title heightWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18 * kLinkContentScale]  constrainedToWidth:maxWidth];
            if (mainTitleH > (kFeedPageViewMaxHeight - mediaViewH)) { /// 限制最大高度
                mainTitleH = (kFeedPageViewMaxHeight - mediaViewH);
            }
            CGRect mainTitleLableFrame = CGRectMake(mainTitleX, mainTitleY, mainTitleW, mainTitleH);
            linkLayout.mainTitleLableFrame = mainTitleLableFrame;
            
            UIFont *contentFont = [UIFont fontWithName:@"PingFangSC-Regular" size:18 * kLinkContentScale];
            CGFloat contentX = 0;
            CGFloat contentY = mainTitleY + (mainTitleH > 0 ? mainTitleH + 5 : 0);
            CGFloat contentW = maxWidth;
            CGFloat contentH = [linkComponent.subTitle heightWithFont:contentFont constrainedToWidth:maxWidth];
            /// 限制文本最大行数 5 行
            CGFloat maxRowHeight = kMaxRow * contentFont.lineHeight;
            if (contentH > maxRowHeight){
                contentH = maxRowHeight;
            }
            /// 限制最大高度
            if ((mainTitleH) >= (kFeedPageViewMaxHeight - mediaViewH)) { /// title已达到最大高度
                contentY = mainTitleY + mainTitleH;
                contentH = 0;
            } else if ((contentY + contentH) > (kFeedPageViewMaxHeight - mediaViewH)) { ///content 位置达到最大高度
                contentY = mainTitleY + mainTitleH;
                contentH = kFeedPageViewMaxHeight - mediaViewH - mainTitleH - 5;
            }
            CGRect contentLableFrame = CGRectMake(contentX, contentY, contentW, contentH);
            linkLayout.contentLableFrame = contentLableFrame;
            
            CGFloat summaryTextViewX = 5;
            CGFloat summaryTextViewY = 5;
            CGFloat summaryTextViewW = maxWidth;
            CGFloat summaryTextViewH = contentY + contentH;
            CGRect summaryTextViewFrame = CGRectMake(summaryTextViewX, summaryTextViewY, summaryTextViewW, summaryTextViewH);
            linkLayout.summaryTextViewFrame = summaryTextViewFrame;
            
            CGFloat mediaViewX = 5;
            CGFloat mediaViewY = summaryTextViewY + (summaryTextViewH > 0 ? summaryTextViewH + 5 : 0);
            
            CGRect mediaViewFrame = CGRectMake(mediaViewX, mediaViewY, mediaViewW, mediaViewH);
            linkLayout.mediaViewFrame = mediaViewFrame;
            
            linkLayout.cellHeight = mediaViewY + mediaViewH + (mediaViewH > 0 ? 5 : 0);
        }
            break;
        case WARFeedLinkComponentTypeSummary:
        {
            /** summary */
            CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - 10;//10是lable在cell中的间距
            CGFloat maxHeight = HUGE;
            
            /** mediaView */
            CGFloat mediaViewW = 0;
            CGFloat mediaViewH = 0;
            switch (linkComponent.summaryType) {
                    case WARFeedLinkSummaryTypeText:
                {
                    
                }
                    break;
                    case WARFeedLinkSummaryTypeVideo:
                {
                    CGFloat videoViewX = 0;
                    CGFloat videoViewY = 0;
                    CGFloat videoViewW = maxWidth;
                    CGFloat videoViewH = maxWidth * 9 / 16;
                    CGRect videoViewFrame = CGRectMake(videoViewX, videoViewY, videoViewW, videoViewH);
                    linkLayout.videoViewFrame = videoViewFrame;
                    
                    mediaViewW = maxWidth;
                    mediaViewH = videoViewH;
                }
                    break;
                    case WARFeedLinkSummaryTypeSingleImg:
                {
                    CGFloat bigImageViewX = 0;
                    CGFloat bigImageViewY = 0;
                    CGFloat bigImageViewW = maxWidth;
                    CGFloat bigImageViewH = maxWidth * 9 / 16;
                    CGRect bigImageViewFrame = CGRectMake(bigImageViewX, bigImageViewY, bigImageViewW, bigImageViewH);
                    linkLayout.bigImageViewFrame = bigImageViewFrame;
                    
                    mediaViewW = maxWidth;
                    mediaViewH = bigImageViewH;
                }
                    break;
                    case WARFeedLinkSummaryTyperipleImg:
                {
                    CGFloat imageContainerX = 0;
                    CGFloat imageContainerY = 0;
                    CGFloat imageContainerW = maxWidth;
                    CGFloat itemW = (imageContainerW - 2 * 3.5) / 3;
                    CGFloat imageContainerH = itemW * 2 / 3;
                    CGRect imageContainerFrame = CGRectMake(imageContainerX, imageContainerY, imageContainerW, imageContainerH);
                    linkLayout.imageContainerFrame = imageContainerFrame;
                    
                    mediaViewW = maxWidth;
                    mediaViewH = imageContainerH ;
                }
                    break;
            }

            /** title */
            CGFloat mainTitleX = 0;
            CGFloat mainTitleY = 0;
            CGFloat mainTitleW = maxWidth;
            CGFloat mainTitleH = [linkComponent.title heightWithFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18 * kLinkContentScale]  constrainedToWidth:maxWidth];
            CGRect mainTitleLableFrame = CGRectMake(mainTitleX, mainTitleY, mainTitleW, mainTitleH);
            linkLayout.mainTitleLableFrame = mainTitleLableFrame;

            /** content */  
            UIFont *contentFont = [UIFont fontWithName:@"PingFangSC-Regular" size:18 * kLinkContentScale];
            CGFloat contentX = 0;
            CGFloat contentY = mainTitleY + (mainTitleH > 0 ? mainTitleH + 5 : 0);
            CGFloat contentW = maxWidth;
            CGFloat contentH = [linkComponent.subTitle heightWithFont:contentFont constrainedToWidth:maxWidth];
            /// 限制文本最大行数 5 行
            CGFloat maxRowHeight = kMaxRow * contentFont.lineHeight;
            if (contentH > maxRowHeight){
                contentH = maxRowHeight;
            }
            /// 限制最大高度
            if ((mainTitleH) >= (kFeedPageViewMaxHeight - mediaViewH)) { /// title已达到最大高度
                contentY = mainTitleY + mainTitleH;
                contentH = 0;
            } else if ((contentY + contentH) > (kFeedPageViewMaxHeight - mediaViewH)) { ///content 位置达到最大高度
                contentY = mainTitleY + mainTitleH;
                contentH = kFeedPageViewMaxHeight - mediaViewH - mainTitleH - 5;
            }
            CGRect contentLableFrame = CGRectMake(contentX, contentY, contentW, contentH);
            linkLayout.contentLableFrame = contentLableFrame;

            CGFloat summaryTextViewX = 5;
            CGFloat summaryTextViewY = 5;
            CGFloat summaryTextViewW = maxWidth;
            CGFloat summaryTextViewH = contentY + (contentH > 0 ? contentH : (contentH - 5));
            CGRect summaryTextViewFrame = CGRectMake(summaryTextViewX, summaryTextViewY, summaryTextViewW, summaryTextViewH);
            linkLayout.summaryTextViewFrame = summaryTextViewFrame;

            CGFloat mediaViewX = 5;
            CGFloat mediaViewY = summaryTextViewY + (summaryTextViewH > 0 ? summaryTextViewH + 5 : 0);
            
            CGRect mediaViewFrame = CGRectMake(mediaViewX, mediaViewY, mediaViewW, mediaViewH);
            linkLayout.mediaViewFrame = mediaViewFrame;

            linkLayout.cellHeight = mediaViewY + mediaViewH + (mediaViewH > 0 ? 5 : 0);

        }
            break;
    }
    return linkLayout;
}

@end
