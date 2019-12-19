//
//  HMHShortVideoMoreTableViewCell.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/24.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoListModel.h"

@interface HMHShortVideoMoreTableViewCell : UITableViewCell

- (void)refreshCellWithModel:(HMHVideoListModel *)model;

@end
