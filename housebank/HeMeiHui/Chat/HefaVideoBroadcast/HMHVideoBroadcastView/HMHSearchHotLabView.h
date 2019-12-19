//
//  HMHSearchHotLabView.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/17.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMHSearchHotLabView;
//协议
@protocol SearchHotLabViewDelegate <NSObject>
@optional

/**
 热门标签按钮的点击事件
 @param labIndex  每个标签的index值
 */
- (void)hotLabClickWithLabIndex:(NSInteger)labIndex;

@end

@interface HMHSearchHotLabView : UIView

@property (nonatomic, weak) id<SearchHotLabViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withDataSource:(NSMutableArray *)datasource;

+(CGFloat)getLabsHeightWithModel:(NSMutableArray *)dataSourceArr;

@end
