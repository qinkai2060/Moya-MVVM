//
//  WARFeedGameLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/3.
//

#import <Foundation/Foundation.h>
#import "WARFeedGame.h"

@interface WARFeedGameLayout : NSObject
/** game */
@property (nonatomic, strong) WARFeedGame *game;

+ (WARFeedGameLayout *)gameLayout:(WARFeedGame *)game isMultiPage:(BOOL)isMultiPage;

@property (nonatomic, assign) CGRect imageFrame; 
@property (nonatomic, assign) CGRect rankViewFrame;

@property (nonatomic, assign) CGFloat contentHeight;

@end

//@interface WARFeedGameRankLayout : NSObject
// 
//
//@end
