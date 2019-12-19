//
//  VideoTopCategoyView.h
//  ihefaTestUI
//
//  Created by Qianhong Li on 2018/4/13.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideoTopCategoryView;
//协议
@protocol VideoCategoryBtnDelegate <NSObject>
@optional

/**
 顶部按钮的点击事件 跳转对应的界面
 @param index 选中按钮的下标
 */
- (void)videoCategoryBtnClickToInfoWithIndex:(NSInteger)index;

@end

@interface VideoTopCategoryView : UIView

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)dataSource;
// 获取当前view的高度
+(CGFloat)getCenterViewHeightWithArr:(NSMutableArray *)arr;

@property (nonatomic,weak) id<VideoCategoryBtnDelegate>delegate;

@end
