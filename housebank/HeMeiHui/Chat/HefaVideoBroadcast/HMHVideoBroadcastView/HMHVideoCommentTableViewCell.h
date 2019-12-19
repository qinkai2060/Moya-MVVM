//
//  HMHVideoCommentTableViewCell.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/19.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoCommentModel.h"

@class HMHVideoCommentTableViewCell;
//协议
@protocol VideoCommentTableViewCellDelegate <NSObject>
@optional

/*
 发表文字的 展开与收起
 @param index 索引
 */
-(void)showAllConentBtnClickWithIndex:(NSInteger)index;

/**
 评论区 赞按钮的点击事件
 @param index 当前点击赞的index
 */
- (void)videoCommentZanBtbClickWithIndex:(NSInteger)index withCommentCell:(HMHVideoCommentTableViewCell *)cell;

@end


@interface HMHVideoCommentTableViewCell : UITableViewCell

@property(nonatomic,weak)id<VideoCommentTableViewCellDelegate>delegate;
//
@property (nonatomic, strong) UIButton *zanBtn;

- (void)refreshTableViewCellWithModel:(HMHVideoCommentModel *)model;

+(CGFloat)cellHeightWithModel:(HMHVideoCommentModel *)model;

@end
