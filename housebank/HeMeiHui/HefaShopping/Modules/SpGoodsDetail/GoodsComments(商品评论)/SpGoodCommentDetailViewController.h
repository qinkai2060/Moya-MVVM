//
//  SpGoodCommentDetailViewController.h
//  HeMeiHui
//
//  Created by liqianhong on 2019/1/14.
//  Copyright © 2019 hefa. All rights reserved.
//

#import "SpBaseViewController.h"
#import "GetCommentListModel.h"
#import "GoodsDetailModel.h"
// 评价详情
NS_ASSUME_NONNULL_BEGIN

@interface SpGoodCommentDetailViewController : SpBaseViewController
// 评论model
@property (nonatomic, strong) GetCommentListModel *listModel;
// 商品model
@property (nonatomic, strong) GoodsDetailModel *detailModel;

// 是否是点击评论按钮进入的
@property (nonatomic, assign) BOOL isCommentIn;

@end

NS_ASSUME_NONNULL_END
