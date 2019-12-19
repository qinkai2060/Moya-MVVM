//
//  SelVideoViewController.h
//  SelVideoPlayer
//
//  Created by zhuku on 2018/1/28.
//  Copyright © 2018年 selwyn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCDownloadItem.h"
#import "SelPlayerConfiguration.h"

@interface SelVideoViewController : UIViewController

@property (nonatomic, strong) YCDownloadItem *playerItem;

- (void)refreshVideoPlayer:(SelPlayerConfiguration*)config;

@end
