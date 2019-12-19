//
//  VipSelPlaybackControls.m
//  SelVideoPlayer
//
//  Created by Tracy on 2019/7/18.
//  Copyright © 2019 selwyn. All rights reserved.
//

#import "VipSelPlaybackControls.h"
#import <Masonry.h>
@implementation VipSelPlaybackControls
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bottomControlsBar.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.8];
        self.progress.tintColor = [UIColor colorWithHexString:@"#FF0000"];
        
        for (UIGestureRecognizer *ges in self.gestureRecognizers) {
             [self removeGestureRecognizer:ges];
        }
        self.fullScreenButton.hidden = YES;
        self.fullScreenButton.enabled= NO;
    
        [self.playTimeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomControlsBar).offset(5);
        }];
        
        [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomControlsBar).offset(-5);
            make.width.equalTo(@45);
        }];
        
    }
    return self;
}

@end
