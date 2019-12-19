//
//  HMHLiveVideoHomeViewXLSController.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/4/29.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import "HMHLiveVideoHomeBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface HMHLiveVideoHomeViewXLSController : HMHLiveVideoHomeBaseViewController
@property (nonatomic,assign)BOOL isShowSearch;

@property (nonatomic, strong) NSString *searchType;

@property (nonatomic, strong) NSString *searchValue;

@property (nonatomic, strong) NSString *tagOrCategoryNameStr;
@end

NS_ASSUME_NONNULL_END
