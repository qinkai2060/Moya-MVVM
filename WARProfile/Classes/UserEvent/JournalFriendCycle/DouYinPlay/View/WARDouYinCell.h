//
//  ZFDouYinCell.h
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import <UIKit/UIKit.h> 
@class WARRecommendVideo;

@interface WARDouYinCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

/** video */
@property (nonatomic, strong) WARRecommendVideo *video;

@end
