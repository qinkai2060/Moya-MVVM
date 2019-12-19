//
//  UIView+addGradientLayer.h
//  housebank
//
//  Created by zhuchaoji on 2018/12/12.
//  Copyright © 2018年 hefa. All rights reserved.
//



NS_ASSUME_NONNULL_BEGIN

@interface UIView (addGradientLayer)
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic, strong) NSTimer *timer2;
-(void)addGradualLayerWithColores:(NSArray *)colorArray;
@end

NS_ASSUME_NONNULL_END
