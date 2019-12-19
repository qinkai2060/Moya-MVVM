//
//  PlayerViewController.h
//  YCDownloadSession
//
//  Created by wz on 2017/9/30.
//  Copyright © 2017年 onezen.cc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCDownloadItem.h"
#import "WMPlayer.h"
#import "HMHBasePrimaryViewController.h"

// 回放 (暂未用)
@interface HMHVideoVodPlayerViewController : HMHBasePrimaryViewController

@property (nonatomic, strong) WMPlayer *player;

@property (nonatomic, strong) YCDownloadItem *playerItem;

@property(nonatomic,strong)NSNumber *indexSelected;/*顺序*/

@property (nonatomic, strong) NSString *videoNo; // 视频number

// 来自观看历史 跳转到指定的时间
@property (nonatomic, assign) double seekTime;

@end
