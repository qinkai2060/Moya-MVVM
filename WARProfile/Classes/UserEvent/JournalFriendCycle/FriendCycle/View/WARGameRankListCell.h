//
//  WARGameRankCell.h
//  WARProfile
//
//  Created by 卧岚科技 on 2018/7/25.
//

#import <UIKit/UIKit.h>
#import "WARFeedGameRank.h"

@interface WARGameRankListCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** rank */
@property (nonatomic, strong) WARFeedGameRank *rank;

@end
