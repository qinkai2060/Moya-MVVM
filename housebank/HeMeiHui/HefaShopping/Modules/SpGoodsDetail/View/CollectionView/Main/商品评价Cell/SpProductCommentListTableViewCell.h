//
//  SpProductCommentListTableViewCell.h
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCommentListModel.h"

NS_ASSUME_NONNULL_BEGIN
// 商品评价列表
@class SpProductCommentListTableViewCell;
//协议
@protocol SpProductCommentListTableViewCellDelegate <NSObject>
@optional
/**
 点击图片预览
 @param indexRow   cell下标
 @param imageIndex cell中图片下标
 */
-(void)CommentListUserTapImageViewWithIndex:(NSInteger)indexRow withCellImageViewsIndex:(NSInteger)imageIndex;

/**
 评论
 @param index 点击行数
 */
- (void)CommentListCommentBtnClickWithIndex:(NSInteger)index andCircleCell:(SpProductCommentListTableViewCell *)circleCell;

/**
 点赞
 @param index 点击行数
 */
- (void)CommentListZanBtnClickWithIndex:(NSInteger)index andCircleCell:(SpProductCommentListTableViewCell *)circleCell;

@end

@interface SpProductCommentListTableViewCell : UITableViewCell

@property(nonatomic,weak)id<SpProductCommentListTableViewCellDelegate>delegate;

/** 点赞 */
@property (nonatomic,strong) UIButton *zanBtn;
/** 评论按钮 */
@property (nonatomic,strong) UIButton *commentBtn;

-(void)refreshCellWithModel:(GetCommentListModel *)model;

+(CGFloat)cellHeightWithModel:(GetCommentListModel *)model;

@end

NS_ASSUME_NONNULL_END
