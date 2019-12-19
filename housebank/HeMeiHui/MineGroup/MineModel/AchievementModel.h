//
//  AchievementModel.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/5/5.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface AchievementData :NSObject<NSCoding>
@property (nonatomic , assign) BOOL              mlsShowFlag;
@end


@interface AchievementModel : SetBaseModel
@property (nonatomic , strong) AchievementData              * data;
@end

NS_ASSUME_NONNULL_END
