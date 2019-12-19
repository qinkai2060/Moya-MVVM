//
//  SpReplyCommentListTableViewCell.h
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/15.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCommentListModel.h"

// 评价回复
NS_ASSUME_NONNULL_BEGIN

// 商品评价列表
@class SpReplyCommentListTableViewCell;
//协议
@protocol SpReplyCommentListTableViewCellDelegate <NSObject>
@optional

/**
 点赞
 @param index 点击行数
 */
- (void)CommentListZanBtnClickWithIndex:(NSInteger)index andCircleCell:(SpReplyCommentListTableViewCell *)circleCell;

@end


@interface SpReplyCommentListTableViewCell : UITableViewCell

@property(nonatomic,weak)id<SpReplyCommentListTableViewCellDelegate>delegate;

/** 点赞 */
@property (nonatomic,strong) UIButton *zanBtn;

#pragma mark ---------- 刷新 ---------
-(void)refreshCellWithModel:(GetCommentListModel *)model;

#pragma mark------------ cell高度 ----------------
+(CGFloat)cellHeightWithModel:(GetCommentListModel *)model;

@end

NS_ASSUME_NONNULL_END
