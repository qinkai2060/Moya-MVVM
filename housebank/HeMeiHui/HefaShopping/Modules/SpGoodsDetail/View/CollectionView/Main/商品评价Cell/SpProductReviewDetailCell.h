//
//  SpProductReviewDetailCell.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/18.
//  Copyright © 2018年 hefa. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ZPMyStarShow.h"
#import "CommentListModel.h"
@interface SpProductReviewDetailCell : UICollectionViewCell

/* 头像 */
@property (strong , nonatomic)UIImageView *iconImageView;
/* 昵称 */
@property (strong , nonatomic)UILabel *nickNameLabel;
/* 评论内容 */
@property (strong , nonatomic)UILabel *contentLabel;
/* 时间 */
@property (strong , nonatomic)UILabel *timeLabel;

/*分类*/
@property (strong , nonatomic)UILabel *showTypeLable;
/*评分*/
@property (strong , nonatomic)ZPMyStarShow *starView;

@property (strong , nonatomic)CommentListModel *commentList;
@property (strong , nonatomic)ListItem *commentItem;
-(void)reSetVDataValue:(ListItem*)productInfo;
@end
