//
//  VolumeViewTools.m
//  HeMeiHui
//
//  Created by Qianhong Li on 2018/6/25.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import "VolumeViewTools.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VolumeViewTools ()

@property (nonatomic, strong) MPVolumeView *mpVolumeView;

@property (nonatomic, strong) UISlider *mpVolumeSlider;


@end

@implementation VolumeViewTools

-(void)createView{
    if (!_mpVolumeView) {
        if (_mpVolumeView == nil) {
            _mpVolumeView = [[MPVolumeView alloc] init];
            
            for (UIView *view in [_mpVolumeView subviews]) {
                if ([view.class.description isEqualToString:@"MPVolumeSlider"]) {
                    _mpVolumeSlider = (UISlider *)view;
                    break;
                }
            }
            [_mpVolumeView setFrame:CGRectMake(-100, -100, 40, 40)];
            [_mpVolumeView setShowsVolumeSlider:YES];
            [_mpVolumeView sizeToFit];
        }
    }
}

- (void)volumeHide{
    [_mpVolumeView setHidden:YES];

}
-(void)volumeShow{
    [_mpVolumeView setHidden:NO];

}

@end
