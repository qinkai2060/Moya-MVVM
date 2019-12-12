//
//  WARMomentTraceInfoView.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/19.
//

#import <UIKit/UIKit.h>
#import "WARMomentTrackInfoLayout.h"

@interface WARMomentTrackInfoView : UIView
/** 初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame trackType:(WARMomentTrackType)trackType;
/** layout */
@property (nonatomic, strong) WARMomentTrackInfoLayout *layout;
@end
