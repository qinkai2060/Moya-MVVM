//
//  DateSelectionView.h
//  HeMeiHui
//
//  Created by zhuchaoji on 2019/4/12.
//  Copyright © 2019年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DateSelectionView : UIView
@property(nonatomic,strong) UILabel *checkInDate;//入住日期
@property(nonatomic,strong) UILabel *departureDate;//离店日期
@property(nonatomic,strong) UILabel *checkInDateTag;//今天
@property(nonatomic,strong) UILabel *departureDateTag;//明天
@property(nonatomic,strong) UILabel *nightsNum;//总共天数

- (CGFloat)calculateRowWidth:(NSString*)string height:(CGFloat)height font:(CGFloat)font;
@end

NS_ASSUME_NONNULL_END
