//
//  VideoPreviewViewController.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/20.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoListModel.h"
#import "HMHBasePrimaryViewController.h"
// 直播预告页
@interface HMHVideoPreviewViewController : HMHBasePrimaryViewController

@property(nonatomic,strong)NSNumber *indexSelected;/*顺序*/

@property (nonatomic, strong) NSString *videoNum;

@end
