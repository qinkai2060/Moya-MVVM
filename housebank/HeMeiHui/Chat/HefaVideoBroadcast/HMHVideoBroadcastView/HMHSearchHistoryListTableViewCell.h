//
//  HMHSearchHistoryListTableViewCell.h
//  mainVideo
//
//  Created by Qianhong Li on 2018/4/16.
//  Copyright © 2018年 Qianhong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMHSearchHistoryListTableViewCell;

typedef void(^cancelBtnClick)(HMHSearchHistoryListTableViewCell *cell);

@interface HMHSearchHistoryListTableViewCell : UITableViewCell

@property (nonatomic, copy) cancelBtnClick cancelBtnClickBlock;

- (void)refreshCellWithSearchStr:(NSString *)searchStr;

@end
