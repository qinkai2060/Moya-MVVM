//
//  WARFeedStoreLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import "WARFeedStoreLayout.h"
#import "WARFeedMacro.h"
#import "WARMacros.h"

@implementation WARFeedStoreLayout

+ (WARFeedStoreLayout *)storeLayout:(WARFeedStore *)store {
    WARFeedStoreLayout *layout = [[WARFeedStoreLayout alloc] init];
    layout.store = store;
    
    CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - 10;
    
    CGFloat bigImageViewX = kFeedNumber(6);
    CGFloat bigImageViewY = kFeedNumber(7);
    CGFloat bigImageViewW = kFeedNumber(110);
    CGFloat bigImageViewH = kFeedNumber(73);
    CGRect bigImageViewFrame = CGRectMake(bigImageViewX, bigImageViewY, bigImageViewW, bigImageViewH);
    layout.imageFrame = bigImageViewFrame;
    
    CGFloat mainTitleX = bigImageViewX + bigImageViewW + kFeedNumber(10);
    CGFloat mainTitleY = kFeedNumber(11);
    CGFloat mainTitleW = maxWidth - kFeedNumber(18) - bigImageViewW;
    CGFloat mainTitleH = kFeedNumber(19) ;
    CGRect mainTitleLableFrame = CGRectMake(mainTitleX, mainTitleY, mainTitleW, mainTitleH);
    layout.titleFrame = mainTitleLableFrame;
    
    CGFloat scoreX = mainTitleX;
    CGFloat scoreY = mainTitleY + mainTitleH + kFeedNumber(7);
    CGFloat scoreW = 83;
    CGFloat scoreH = 15;
    CGRect scoreLableFrame = CGRectMake(scoreX, scoreY, scoreW, scoreH);
    layout.scoreFrame = scoreLableFrame;
    
    CGFloat priceX = scoreX + scoreW + kFeedNumber(8.5);
    CGFloat priceY = scoreY - 2;
    CGFloat priceW = maxWidth - kFeedNumber(18) - bigImageViewW;
    CGFloat priceH = 19;
    CGRect priceLableFrame = CGRectMake(priceX, priceY, priceW, priceH);
    layout.priceFrame = priceLableFrame;
    
    CGFloat contentX = mainTitleX ;
    CGFloat contentY = scoreY + scoreH + kFeedNumber(8);
    CGFloat contentW = maxWidth - bigImageViewW;
    CGFloat contentH = 15;
    CGRect contentLableFrame = CGRectMake(contentX, contentY, contentW, contentH);
    layout.locationFrame = contentLableFrame;
    
    CGFloat imageContainerX = bigImageViewX ;
    CGFloat imageContainerY = bigImageViewY + bigImageViewH + kFeedNumber(8);
    CGFloat imageContainerW = maxWidth;
    CGFloat imageContainerH = kFeedNumber(55);
    CGRect imageContainerFrame = CGRectMake(imageContainerX, imageContainerY, imageContainerW, imageContainerH);
    layout.imageContainerFrame = imageContainerFrame;
    
    layout.contentHeight = CGRectGetMaxY(layout.imageContainerFrame) + kFeedNumber(11);
    
    return layout;
}

@end
