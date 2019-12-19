//
//  CacheListTableViewCell.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

@interface HMHVideoCacheListTableViewCell : MGSwipeTableCell

- (void)refreshCellWithModel:(id)model;

@end
