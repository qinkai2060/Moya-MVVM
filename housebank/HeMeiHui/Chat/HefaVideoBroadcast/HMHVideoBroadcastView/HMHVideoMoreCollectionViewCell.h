//
//  HMHVideoMoreCollectionViewCell.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/19.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMHVideoMoreCollectionViewCell;
//协议
@protocol VideoMoreCollectionViewCellDelegate <NSObject>
@optional

/**
 下载或者暂停 按钮的点击事件
 @param index 当前的cell的index
 */
- (void)videoButtonClickToDownLoadWithIndex:(NSInteger)index;

/**
 点自己中间的下载中 改变下载的状态 （下载中  暂停 等状态）
 @param index 当前cell的index
 */
- (void)centerButtonClickToChangeDownLoadStatesWithCell:(HMHVideoMoreCollectionViewCell *)cell Index:(NSInteger)index;

@end

// 更多精彩
@interface HMHVideoMoreCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<VideoMoreCollectionViewCellDelegate>delegate;

- (void)refreshCellWithModel:(id)model;

@end
