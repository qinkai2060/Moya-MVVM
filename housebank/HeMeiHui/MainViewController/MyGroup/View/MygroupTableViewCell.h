//
//  MygroupTableViewCell.h
//  HeMeiHui
//
//  Created by Tracy on 2019/5/16.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXViewProtocol.h"
#import "ZJJTimeCountDown.h"
#import "ZJJTimeCountDownDateTool.h"
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, StateType) {
    UnderNowType, // 正在进行
    WillBegainType, // 即将开始
    EndType, // 已结束
};
@interface MygroupTableViewCell : UITableViewCell <JXViewProtocol>
@property (nonatomic ,assign) StateType changeType;
@property (nonatomic ,strong) ZJJTimeCountDownLabel *twoTimeLabel;
@property (nonatomic ,strong) ZJJTimeCountDown *countDown;
@property (nonatomic, copy)   NSString * speaceTime;
@end

NS_ASSUME_NONNULL_END
