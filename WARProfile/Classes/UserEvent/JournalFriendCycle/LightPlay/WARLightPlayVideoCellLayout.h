//
//  WARLightPlayVideoCellLayout.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/6/28.
//

#import <Foundation/Foundation.h>
@class WARRecommendVideo;

@interface WARLightPlayVideoCellLayout : NSObject
/** video */
@property (nonatomic, strong) WARRecommendVideo *video;

+ (WARLightPlayVideoCellLayout *)layoutWithVideo:(WARRecommendVideo *)video;

@property (nonatomic, assign) CGRect coverImageViewFrame;
@property (nonatomic, assign) CGRect userImageViewFrame;
@property (nonatomic, assign) CGRect likeBtnFrame;
@property (nonatomic, assign) CGRect commentBtnFrame;
@property (nonatomic, assign) CGRect playBtnFrame;
@property (nonatomic, assign) CGRect titleLabelFrame;
@property (nonatomic, assign) CGRect nameLabelFrame;
@property (nonatomic, assign) CGRect maskViewRect;

/** isVerticalVideo */
@property (nonatomic, assign) BOOL isVerticalVideo;
/** cellHeight */
@property (nonatomic, assign) CGFloat cellHeight;
@end
