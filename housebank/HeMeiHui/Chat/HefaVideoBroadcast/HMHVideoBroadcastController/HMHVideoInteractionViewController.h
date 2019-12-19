//
//  VideoInteractionViewController.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/20.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoListModel.h"
#import "HMHBasePrimaryViewController.h"
// 直播预告 - 互动
@interface HMHVideoInteractionViewController : HMHBasePrimaryViewController

@property(nonatomic,copy)void(^myBlock)(UIViewController *vc);/*回调*/

@property (nonatomic, strong) NSString *videoNum;

@end
