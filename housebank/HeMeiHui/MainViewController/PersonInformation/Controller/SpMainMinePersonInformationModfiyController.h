//
//  SpMainMinePersonInformationModfiyController.h
//  HeMeiHui
//
//  Created by 玖粤科技 on 2019/5/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "HMHBaseNewScrollViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^Success)(NSString *str);

@interface SpMainMinePersonInformationModfiyController : HMHBaseNewScrollViewController

@property (nonatomic,assign)PersonInformationType currentType;

@property (nonatomic, copy) NSString * passValue;

@property (nonatomic,copy)Success success;

@end

NS_ASSUME_NONNULL_END
