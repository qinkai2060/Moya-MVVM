//
//  SpFeatureItemCell.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/18.
//  Copyright © 2018年 hefa. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GoodsDetailModel.h"
#import "CommentListModel.h"
@interface SpProductReviewCell : UICollectionViewCell
@property (nonatomic, strong) CommentListModel *commentList;
-(void)reSetVDataValue:(CommentListModel*)productInfo;
@end
