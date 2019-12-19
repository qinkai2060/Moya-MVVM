//
//  CollectTableViewCell.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/28.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import "MGSwipeTableCell.h"
#import "HMHVideoListModel.h"

@interface HMHCollectTableViewCell : MGSwipeTableCell

- (void)refreshCellWithModel:(HMHVideoListModel *)model;

@end
