//
//  SpProductCommentDetailTableViewCell.h
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCommentListModel.h"

NS_ASSUME_NONNULL_BEGIN

@class SpProductCommentDetailTableViewCell;
//协议
@protocol SpProductCommentDetailTableViewCellDelegate <NSObject>
@optional
/**
 点击图片预览
 @param imageIndex cell中图片下标
 */
-(void)CommentListUserTapImageViewWithCellImageViewsIndex:(NSInteger)imageIndex;

@end

@interface SpProductCommentDetailTableViewCell : UIView

@property(nonatomic,weak)id<SpProductCommentDetailTableViewCellDelegate>delegate;

- (void)refreshDetailCellWithModel:(GetCommentListModel *)model;

+(CGFloat)cellHeightWithModel:(GetCommentListModel *)model;

@end

NS_ASSUME_NONNULL_END
