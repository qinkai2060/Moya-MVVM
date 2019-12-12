//
//  WARDouYinControlView.h
//  WARPlayer_Example
//
//  Created by 任子丰 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WARPlayer.h"

static NSInteger kCoverImageViewTag = 100;

@class WARRecommendVideo;
@class WARDouYinControlView;

@protocol WARDouYinControlViewDelegate <NSObject>
- (void)controlViewDidComment:(WARDouYinControlView *)controlView video:(WARRecommendVideo *)video;
- (void)controlViewDidPraise:(WARDouYinControlView *)controlView video:(WARRecommendVideo *)video;
@end

@interface WARDouYinControlView : UIView <WARPlayerMediaControl>

/** delegate */
@property (nonatomic, weak) id<WARDouYinControlViewDelegate> delegate;
/** video */
@property (nonatomic, strong) WARRecommendVideo *video;

- (void)resetControlView;

- (void)showTitle:(NSString *)title coverURLString:(NSString *)coverUrl;


@end
