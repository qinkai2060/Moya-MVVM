//
//  SpProductReviewHeaderView.h
//  housebank
//
//  Created by zhuchaoji on 2018/11/18.
//  Copyright © 2018年 hefa. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface SpProductReviewHeaderView : UICollectionReusableView

/* 评论数量 */
@property (copy , nonatomic)NSString *comNum;

/* 查看全部*/
@property (copy , nonatomic)NSString *wellPer;
- (void)setComNum:(NSString *)comNum;
@end
