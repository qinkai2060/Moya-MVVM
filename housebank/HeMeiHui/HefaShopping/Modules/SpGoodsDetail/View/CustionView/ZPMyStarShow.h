//
//  ZPMyStarShow.h
//  housebank
//
//  Created by zhuchaoji on 2018/12/22.
//  Copyright © 2018年 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZPMyStarShow;
/** *  星级评分条代理 */
@protocol ZPMyStarShowDelegate
/**
 *  评分改变
 *  @param ratingBar 评分控件
 *  @param newRating 评分值
 */
- (void)ratingBar:(ZPMyStarShow *)ratingBar ratingChanged:(float)newRating;
@end

@interface ZPMyStarShow : UIView
/** *  初始化设置未选中图片、半选中图片、全选中图片，以及评分值改变的代理（可以用 *  Block）实现 *
*  deselectedName  未选中图片名称
*  halfSelectedName 半选中图片名称
*  fullSelectedName 全选中图片名称
*  delegate          代理 */
- (void)setImageDeselected:(NSString *)deselectedName halfSelected:(NSString *)halfSelectedName fullSelected:(NSString *)fullSelectedName andDelegate:(id)delegate;
/**
 *  是否是指示器，如果是指示器，就不能滑动了，只显示结果，不是指示器的话就能滑动修改值
 
 *  默认为NO
 */
-(void)setStarRating:(CGFloat)starRating;
@property (nonatomic,assign) BOOL isIndicator;
/**
 *  当前应显示的星星数
 *  默认设置是0
 */
@property (assign, nonatomic) CGFloat starRating;

@end

NS_ASSUME_NONNULL_END
