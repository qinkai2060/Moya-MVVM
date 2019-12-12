//
//  WARSimpleSceneryLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/21.
//

#import <Foundation/Foundation.h>
#import "WARFeedScenery.h"

@interface WARSimpleSceneryLayout : NSObject

/** scenery */
@property (nonatomic, strong) WARFeedScenery *scenery;

+ (WARSimpleSceneryLayout *)simpleSceneryLayout:(WARFeedScenery *)scenery;

@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGRect titleFrame;
@property (nonatomic, assign) CGRect locationFrame;

@end
