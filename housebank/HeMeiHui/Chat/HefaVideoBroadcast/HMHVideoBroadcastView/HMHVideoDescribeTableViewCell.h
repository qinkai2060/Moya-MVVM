//
//  HMHVideoDescribeTableViewCell.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/24.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoListModel.h"
@class HMHVideoDescribeTableViewCell;
//协议
@protocol VideoDescribeTableViewCellDelegate <NSObject>
@optional

/*
 发表文字的 展开与收起
 @param index 索引
 */
-(void)showAllConentBtnClickWithIndex:(NSInteger)index;

@end

@interface HMHVideoDescribeTableViewCell : UITableViewCell

@property(nonatomic,weak)id<VideoDescribeTableViewCellDelegate>delegate;


- (void)refreshCellWithModel:(HMHVideoListModel *)model;

+(CGFloat)cellHeightWithModel:(HMHVideoListModel *)model;
@end
