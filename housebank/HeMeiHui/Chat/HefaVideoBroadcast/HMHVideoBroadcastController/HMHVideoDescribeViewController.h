//
//  VideoDescribeViewController.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/20.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHBasePrimaryViewController.h"
#import "HMHVideoListModel.h"

#import "HMHPopAppointViewController.h"
// 直播预告 - 简介
@interface HMHVideoDescribeViewController : HMHPopAppointViewController

@property(nonatomic,copy)void(^myBlock)(UIViewController *vc);/*回调*/


@property(nonatomic,copy)void(^myPopBlock)(UIViewController *vc);/*回调*/

@property (nonatomic, strong) HMHVideoListModel *HMH_listModel;

// 是否来自回放
@property (nonatomic, assign) BOOL isFromVodPlay;

@property (nonatomic, strong) NSString *videoNum;

@end
