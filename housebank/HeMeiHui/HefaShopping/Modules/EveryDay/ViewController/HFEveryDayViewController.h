//
//  HFEveryDayViewController.h
//  HeMeiHui
//
//  Created by usermac on 2019/3/25.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "HMHBasePrimaryViewController.h"


@interface HFEveryDayViewController : SpBaseViewController

@property (nonatomic, strong) NSString *classId;
// 表示等级 1 2 3
@property (nonatomic, strong) NSString *level;
// 搜索文字
@property (nonatomic, strong) NSString *searchStr;

@property (nonatomic, assign) BOOL isFristIn;

@end

