//
//  WARJournalThumbLayout.h
//  AFNetworking
//
//  Created by 卧岚科技 on 2018/6/13.
//

#import <Foundation/Foundation.h>
@class WARThumbModel;

@interface WARJournalThumbLayout : NSObject
 
+ (WARJournalThumbLayout *)layoutWithThumb:(WARThumbModel *)thumb;

/** likeview frame */
@property (nonatomic, assign) CGRect likeViewFrame;

@property (nonatomic, assign) CGRect likeIconFrame;
@property (nonatomic, assign) CGRect likeBgImageViewFrame;
@property (nonatomic, assign) CGRect likeLabelFrame;
@property (nonatomic, assign) CGRect likeLableBottomLineFrame;
@property (nonatomic, assign) CGRect extendLikeFrame;
@property (nonatomic, assign) CGRect separatorFrame;

@property (nonatomic, assign) CGFloat cellHeight;
@end
