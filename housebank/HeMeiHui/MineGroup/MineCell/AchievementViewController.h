//
//  AchievementViewController.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/5/5.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AchievementViewController : UIViewController
@property(nonatomic,strong) UIView *view1;
@property(nonatomic,strong)UILabel *rmLab;
@property(nonatomic,strong)UILabel *shopLab;
-(void)setDatavale:(NSString *)rmvale shopLab:(NSString *)shopLab;
@end

NS_ASSUME_NONNULL_END
