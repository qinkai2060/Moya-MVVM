//
//  HMHShortVideoViewController.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/24.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoListModel.h"
#import "HMHBasePrimaryViewController.h"
// 短页频页
@interface HMHShortVideoViewController : HMHBasePrimaryViewController

@property (nonatomic, strong) NSString *videoNo;

// 来自观看历史 跳转到指定的时间
@property (nonatomic, assign) double seekTime;

@end
