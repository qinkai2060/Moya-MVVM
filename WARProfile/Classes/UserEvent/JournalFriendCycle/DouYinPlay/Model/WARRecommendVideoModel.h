//
//  WARRecommendVideoModel.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/27.
//

#import <Foundation/Foundation.h>
#import "WARRecommendVideo.h"

@interface WARRecommendVideoModel : NSObject
/** refId */
@property (nonatomic, copy) NSString *refId;
/** videos */
@property (nonatomic, strong) NSMutableArray <WARRecommendVideo *>*videos;
@end
