//
//  SpCommentListDetailMainView.h
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GetCommentListModel.h"
#import "GoodsDetailModel.h"
#import "SpCommentDetailToolBar.h"

NS_ASSUME_NONNULL_BEGIN

@class SpCommentListDetailMainView;
//协议
@protocol SpCommentListDetailMainViewDelegate <NSObject>
@optional
/**
 点击图片预览
 @param imageIndex cell中图片下标
 */
-(void)CommentListMainUserTapImageViewWithCellImageViewsIndex:(NSInteger)imageIndex commentListModel:(GetCommentListModel *)listModel;

/**
 回复评论 发送内容
 */
- (void)sendReplyContentWithText:(NSString *)replyText;

/**
 点赞按钮的点击事件
 index 点赞当前的cell
 zanNum 判断当前是点赞还是取消点赞
 */
- (void)CommentListZanBtnClickWithIndex:(NSInteger)index zanNum:(NSString *)zanNum model:(GetCommentListModel *)model;


-(void)replyConentErrorInfoWithAlert:(UIAlertController *)alertVC;

@end

@interface SpCommentListDetailMainView : UIView

@property(nonatomic,weak)id<SpCommentListDetailMainViewDelegate>delegate;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) SpCommentDetailToolBar *commentToolBar;

// 评论model
@property (nonatomic, strong) GetCommentListModel *commentListModel;

// 商品model
@property (nonatomic, strong) GoodsDetailModel *detailModel;

- (instancetype)initWithFrame:(CGRect)frame WithModel:(GetCommentListModel *)model;

- (void)refreshViewWithData:(NSMutableArray *)dataSource replyTotalNum:(NSInteger)replyTotalNum;
@end

NS_ASSUME_NONNULL_END
