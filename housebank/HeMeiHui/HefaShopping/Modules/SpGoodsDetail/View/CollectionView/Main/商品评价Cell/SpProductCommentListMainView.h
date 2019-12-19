//
//  SpProductCommentListMainView.h
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/12.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCommentListModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SpProductCommentListMainView;
//协议
@protocol SpProductCommentListMainViewDelegate <NSObject>
@optional
/**
 点击图片预览
 @param indexRow   cell下标
 @param imageIndex cell中图片下标
 */
-(void)CommentListMainUserTapImageViewWithIndex:(NSInteger)indexRow withCellImageViewsIndex:(NSInteger)imageIndex;

/**
 评论
 @param index 点击行数
 */
- (void)CommentListMainCommentBtnClickWithIndex:(NSInteger)index;

/**
 点赞评论
 zanNum 当前点赞的状态
 model  当前评价的model
 */
- (void)commentListZanBtnClickWithIndex:(NSInteger)index zanNum:(NSString *)zanNum model:(GetCommentListModel *)model;

//tableview的点击事件
- (void)commentListMainTabelViewDidSelectedWithIndexRow:(NSInteger)indexRow;

@end
@interface SpProductCommentListMainView : UIView

@property(nonatomic,weak)id<SpProductCommentListMainViewDelegate>delegate;

@property (nonatomic, strong) UITableView *tableView;

// 刷新数据
- (void)refreshViewWithData:(NSMutableArray *)dataSource;

@end

NS_ASSUME_NONNULL_END
