//
//  WARFeedLinkLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/7/3.
//

#import <Foundation/Foundation.h>

@class WARFeedLinkComponent;
@interface WARFeedLinkLayout : NSObject

/** linkComponent */
@property (nonatomic, strong) WARFeedLinkComponent *linkComponent;

+ (WARFeedLinkLayout *)linkLayout:(WARFeedLinkComponent *)linkComponent;

/** default */
@property (nonatomic, assign) CGRect imageFrame;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) CGRect textFrame;
@property (nonatomic, assign) CGFloat textWidth;
@property (nonatomic, assign) CGFloat textHeight;

/** summary */
@property (nonatomic, assign) CGRect contentViewFrame;
@property (nonatomic, assign) CGRect summaryTextViewFrame;
@property (nonatomic, assign) CGRect mainTitleLableFrame;
@property (nonatomic, assign) CGRect contentLableFrame;
@property (nonatomic, assign) CGRect mediaViewFrame;
@property (nonatomic, assign) CGRect videoViewFrame;
@property (nonatomic, assign) CGRect bigImageViewFrame;
@property (nonatomic, assign) CGRect imageContainerFrame;

@property (nonatomic, assign) CGFloat cellHeight;
@end
