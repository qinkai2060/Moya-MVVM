//
//  WARFeedSceneryLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import "WARFeedSceneryLayout.h"
#import "WARFeedMacro.h"
#import "WARMacros.h"
#import "NSString+Size.h"

#define kMaxRow 5

@interface WARFeedSceneryLayout()

@end

@implementation WARFeedSceneryLayout

+ (WARFeedSceneryLayout *)sceneryLayout:(WARFeedScenery *)scenery {
    WARFeedSceneryLayout *layout = [[WARFeedSceneryLayout alloc] init];
    layout.scenery = scenery;
    
    CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - 10;
    
    CGFloat mainTitleX = kFeedNumber(6);
    CGFloat mainTitleY = kFeedNumber(7);
    CGFloat mainTitleW = maxWidth - 2 * mainTitleX;
    CGFloat mainTitleH = kFeedNumber(19) ;
    CGRect mainTitleLableFrame = CGRectMake(mainTitleX, mainTitleY, mainTitleW, mainTitleH);
    layout.titleFrame = mainTitleLableFrame;
    
    CGFloat bigImageViewX = mainTitleX;
    CGFloat bigImageViewY = mainTitleY + mainTitleH + kFeedNumber(7);
    CGFloat bigImageViewW = kFeedNumber(217.5);
    CGFloat bigImageViewH = bigImageViewW * 5 / 7.0;
    CGRect bigImageViewFrame = CGRectMake(bigImageViewX, bigImageViewY, bigImageViewW, bigImageViewH);
    layout.imageFrame = bigImageViewFrame;
    
    CGFloat rightTopImageX = bigImageViewX + bigImageViewW + kFeedNumber(4);
    CGFloat rightTopImageY = bigImageViewY;
    CGFloat rightTopImageW = kFeedNumber(115.5);
    CGFloat rightTopImageH = kFeedNumber(77);
    CGRect rightTopImageFrame = CGRectMake(rightTopImageX, rightTopImageY, rightTopImageW, rightTopImageH);
    layout.rightTopImageFrame = rightTopImageFrame;
    
    CGFloat rightBottomImageX = rightTopImageX;
    CGFloat rightBottomImageY = rightTopImageY + rightTopImageH + kFeedNumber(3.5);
    CGFloat rightBottomImageW = rightTopImageW;
    CGFloat rightBottomImageH = rightTopImageH;
    CGRect rightBottomImageFrame = CGRectMake(rightBottomImageX, rightBottomImageY, rightBottomImageW, rightBottomImageH);
    layout.rightBottomImageFrame = rightBottomImageFrame;
    
    UIFont *contentFont = [UIFont fontWithName:@"PingFangSC-Regular" size:kFeedFontSize(18)];
    CGFloat contentX = mainTitleX ;
    CGFloat contentY = bigImageViewY + bigImageViewH + kFeedNumber(8);
    CGFloat contentW = mainTitleW;
    CGFloat contentH = [scenery.subTitle heightWithFont:contentFont constrainedToWidth:contentW];
    /// 限制文本最大行数 5 行
    CGFloat maxRowHeight = kMaxRow * contentFont.lineHeight;
    if (contentH > maxRowHeight){
        contentH = maxRowHeight;
    } 
//    if (contentH > kFeedNumber(100)) {
//        contentH = kFeedNumber(100);
//    }
    
    CGRect contentLableFrame = CGRectMake(contentX, contentY, contentW, contentH);
    layout.contentFrame = contentLableFrame;
    
    layout.contentHeight = CGRectGetMaxY(layout.contentFrame) + kFeedNumber(9);
    
    return layout;
}

@end
