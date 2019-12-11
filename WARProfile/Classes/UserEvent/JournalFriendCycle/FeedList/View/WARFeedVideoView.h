//
//  WARFeedVideoView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/20.
//

#import <UIKit/UIKit.h>
#import "WARFeedMedia.h"

typedef void(^WARFeedVideoViewDidPlayBlock)(NSString *videoId);

@interface WARFeedVideoView : UIView
/** media */
@property (nonatomic, strong) WARFeedMedia *media;
/** didPlayBlock */
@property (nonatomic, copy) WARFeedVideoViewDidPlayBlock didPlayBlock;
@end
