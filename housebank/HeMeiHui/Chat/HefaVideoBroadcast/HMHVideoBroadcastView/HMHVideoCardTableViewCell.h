//
//  HMHVideoCardTableViewCell.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/24.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoCommentModel.h"

@class HMHVideoCardTableViewCell;
//协议
@protocol VideoCardTableViewCellDelegate <NSObject>
@optional

/**
 评论区 赞按钮的点击事件
 @param index 当前点击赞的index
 */
- (void)videoCardCommentZanBtbClickWithIndex:(NSInteger)index withTableViewCell:(HMHVideoCardTableViewCell *)cell;

@end

@interface HMHVideoCardTableViewCell : UITableViewCell

- (void)refreshCellWithModel:(HMHVideoCommentModel *)model;

+(CGFloat)cellHeightWithModel:(HMHVideoCommentModel *)model;

@property (nonatomic, weak) id<VideoCardTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIButton *zanBtn;

@end
