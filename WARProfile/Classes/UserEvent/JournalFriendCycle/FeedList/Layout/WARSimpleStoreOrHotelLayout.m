//
//  WARSimpleStoreOrHotelLayout.m
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import "WARSimpleStoreOrHotelLayout.h"
#import "WARFeedMacro.h"
#import "WARMacros.h"

@implementation WARSimpleStoreOrHotelLayout

+ (WARSimpleStoreOrHotelLayout *)simpleStoreLayout:(WARFeedStore *)store {
    WARSimpleStoreOrHotelLayout *layout = [[WARSimpleStoreOrHotelLayout alloc] init];
    layout.store = store;
    
    CGFloat maxWidth = (kScreenWidth - kFeedMainContentLeftMargin - kCellContentMargin) - 10;
    
    CGFloat bigImageViewX = 0;
    CGFloat bigImageViewY = 0;
    CGFloat bigImageViewW = kLinkContentScale * 84;
    CGFloat bigImageViewH = bigImageViewW;
    CGRect bigImageViewFrame = CGRectMake(bigImageViewX, bigImageViewY, bigImageViewW, bigImageViewH);
    layout.imageFrame = bigImageViewFrame;
    
    CGFloat mainTitleX = bigImageViewW + 10 * kLinkContentScale;
    CGFloat mainTitleY = 11 * kLinkContentScale;
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
    CGFloat priceW = maxWidth - 18 * kLinkContentScale - bigImageViewW;
    CGFloat priceH = 19;
    CGRect priceLableFrame = CGRectMake(priceX, priceY, priceW, priceH);
    layout.priceFrame = priceLableFrame;
    
    CGFloat contentX = mainTitleX ;
    CGFloat contentY = scoreY + scoreH + kFeedNumber(8);
    CGFloat contentW = maxWidth - bigImageViewW;
    CGFloat contentH = 15;
    CGRect contentLableFrame = CGRectMake(contentX, contentY, contentW, contentH);
    layout.locationFrame = contentLableFrame;
    
    return layout;
}

@end
