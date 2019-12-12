//
//  WARFeedSceneryLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import <Foundation/Foundation.h>
#import "WARFeedScenery.h"

@interface WARFeedSceneryLayout : NSObject

/** scenery */
@property (nonatomic, strong) WARFeedScenery *scenery;

+ (WARFeedSceneryLayout *)sceneryLayout:(WARFeedScenery *)scenery;

@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect rightTopImageFrame;
@property (nonatomic, assign) CGRect rightBottomImageFrame;
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGRect contentFrame;

@property (nonatomic, assign) CGFloat contentHeight;
@end
