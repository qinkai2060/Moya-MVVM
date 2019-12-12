//
//  WARGameWebRightView.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/24.
//

#import <UIKit/UIKit.h>

typedef void(^WARGameWebRightViewActionBlock)(void);

@interface WARGameWebRightView : UIView

@property (nonatomic, copy) WARGameWebRightViewActionBlock moreBlock;
@property (nonatomic, copy) WARGameWebRightViewActionBlock closeBlock;

@end
