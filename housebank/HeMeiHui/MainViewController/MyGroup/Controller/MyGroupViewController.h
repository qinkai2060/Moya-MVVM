//
//  MyGroupViewController.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, MyGroup_selectType) {
    MyOpenGroup, // 我开的团
    MyJoinGroup, // 我参加的团
};
@interface MyGroupViewController : SpBaseViewController
@property (nonatomic, assign) MyGroup_selectType myGroupType;
@end

NS_ASSUME_NONNULL_END
