//
//  VideoMorewonderfulViewController.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/18.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoListModel.h"
#import "HMHBasePrimaryViewController.h"
// 更多精彩
@interface HMHVideoMorewonderfulViewController:HMHBasePrimaryViewController

@property(nonatomic,copy)void(^myBlock)(UIViewController *vc);/*回调*/

@property (nonatomic, strong) NSString *videoNum;

@end
