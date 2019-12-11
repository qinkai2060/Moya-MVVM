//
//  WARFeedMagicImageView.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/5/16.
//

#import <UIKit/UIKit.h>
#import "WARFeedModel.h"

@interface WARFeedMagicImageView : UIImageView

/** 内容缩放比 */
@property (nonatomic, assign) CGFloat contentScale;

/** 图片 */
@property (nonatomic, strong) NSArray <WARFeedImageComponent *>*images;

/** 被点击的图片 */
@property (nonatomic, strong) WARFeedImageComponent *didImageComponent;

@end
