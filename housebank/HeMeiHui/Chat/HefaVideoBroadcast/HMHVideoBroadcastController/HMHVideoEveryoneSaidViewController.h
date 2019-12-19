//
//  VideoEveryoneSaidViewController.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/18.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHBasePrimaryViewController.h"
// 大家说
@interface HMHVideoEveryoneSaidViewController:HMHBasePrimaryViewController

@property(nonatomic,copy)void(^myBlock)(UIViewController *vc);/*回调*/

@property(nonatomic,copy)void(^myLoginBlock)(UIViewController *vc);/*回调*/


@property (nonatomic, strong) NSString *videoNum;

@end
