//
//  HMHVideoHotSearchListTableViewCell.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHVideoTagsModel.h"

@interface HMHVideoHotSearchListTableViewCell : UITableViewCell

- (void)refreshCellWithModel:(HMHVideoTagsModel *)model;

@end
