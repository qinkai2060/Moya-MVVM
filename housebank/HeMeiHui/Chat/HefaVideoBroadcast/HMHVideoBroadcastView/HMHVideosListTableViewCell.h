//
//  VideosListTableViewCell.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/28.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoListModel.h"
// 列表页
@interface HMHVideosListTableViewCell : UITableViewCell

- (void)refreshCellWithModel:(HMHVideoListModel *)model;

@end
