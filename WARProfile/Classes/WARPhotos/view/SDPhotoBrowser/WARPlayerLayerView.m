//
//  WARPlayerLayerView.m
//  WARProfile
//
//  Created by 秦恺 on 2018/6/7.
//

#import "WARPlayerLayerView.h"
#import <AVFoundation/AVFoundation.h>
@implementation WARPlayerLayerView

+ (Class)layerClass {
    
    return [AVPlayerLayer class];
}


@end
