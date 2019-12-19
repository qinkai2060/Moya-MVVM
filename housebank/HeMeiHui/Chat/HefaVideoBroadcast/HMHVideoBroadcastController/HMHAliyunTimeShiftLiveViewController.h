//
//  AliyunTimeShiftLiveViewController.h
//  AliyunPlayerMediaDemo
//
//  Created by 王凯 on 2017/12/28.
//  Copyright © 2017年 com.alibaba.ALPlayerVodSDK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AliyunVodPlayerSDK/AliyunVodPlayer.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HMHBasePrimaryViewController.h"

//手势操作的类型
typedef NS_ENUM(NSUInteger,TimeShiftControlType) {
    TimeprogressControl,//视频进度调节操作
    TimevoiceControl,//声音调节操作
    TimelightControl,//屏幕亮度调节操作
    TimenoneControl//无任何操作
} ;

// 直播
@interface HMHAliyunTimeShiftLiveViewController : HMHBasePrimaryViewController
//播放器sdk
@property (nonatomic, strong) AliyunVodPlayer *vodPlayer;

@property(nonatomic,strong)NSNumber *indexSelected;/*顺序*/

@property (nonatomic, strong) NSString *videoNum;

@end
